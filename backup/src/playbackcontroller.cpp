#include "playbackcontroller.h"

#include "SettingsBridge.hpp"

#include <QByteArray>
#include <QCollator>
#include <QDateTime>
#include <QDir>
#include <QDirIterator>
#include <QFileDevice>
#include <QFileInfo>
#include <QFile>
#include <QLocale>
#include <QRegularExpression>
#include <QTime>
#include <QUrl>
#include <QtEndian>

#include <array>
#include <algorithm>
#include <cmath>

#include <tiffio.h>

#include "dngdecoder.h"
#include "tiffhelper.h"

namespace {
QStringList dngNameFilters()
{
    return {QStringLiteral("*.dng"), QStringLiteral("*.DNG")};
}

QString formatShotDateTime(const QString &rawDate)
{
    const QDateTime parsed = QDateTime::fromString(rawDate.trimmed(), QStringLiteral("yyyy:MM:dd HH:mm:ss"));
    if (parsed.isValid()) {
        return QLocale::system().toString(parsed, QStringLiteral("dd MMM yyyy  HH:mm"));
    }
    return rawDate.trimmed();
}

QString shotDateTimeForFrame(const QString &filePath)
{
    TIFF *tiff = openTiffWithCustomTags(filePath, "r");
    char *dateTimeValue = nullptr;
    QString formattedDate;
    if (tiff) {
        if (TIFFGetField(tiff, kTiffTagDateTimeOriginal, &dateTimeValue) && dateTimeValue) {
            formattedDate = formatShotDateTime(QString::fromLatin1(dateTimeValue));
        } else if (TIFFGetField(tiff, TIFFTAG_DATETIME, &dateTimeValue) && dateTimeValue) {
            formattedDate = formatShotDateTime(QString::fromLatin1(dateTimeValue));
        }
        TIFFClose(tiff);
    }

    if (!formattedDate.isEmpty()) {
        return formattedDate;
    }

    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        return {};
    }

    const QString fileText = QString::fromLatin1(file.readAll());
    const QRegularExpression timestampPattern(QStringLiteral(R"((20\d\d:\d\d:\d\d \d\d:\d\d:\d\d))"));
    const QRegularExpressionMatch match = timestampPattern.match(fileText);
    if (!match.hasMatch()) {
        return {};
    }

    return formatShotDateTime(match.captured(1));
}

QString formatByteSize(quint64 bytes)
{
    static const char *kUnits[] = {"B", "KB", "MB", "GB", "TB"};
    double value = static_cast<double>(bytes);
    int unitIndex = 0;
    while (value >= 1024.0 && unitIndex < 4) {
        value /= 1024.0;
        ++unitIndex;
    }

    const int precision = value >= 100.0 || unitIndex == 0 ? 0 : 1;
    return QStringLiteral("%1 %2").arg(QString::number(value, 'f', precision), QString::fromLatin1(kUnits[unitIndex]));
}

QString formatDurationText(int frameCount, double fps)
{
    if (frameCount <= 0 || fps <= 0.0) {
        return QStringLiteral("Unavailable");
    }

    const qint64 totalMs = qRound64((static_cast<double>(frameCount) / fps) * 1000.0);
    const QTime duration = QTime(0, 0).addMSecs(static_cast<int>(totalMs));
    return totalMs >= 3600000
           ? duration.toString(QStringLiteral("hh:mm:ss"))
           : duration.toString(QStringLiteral("mm:ss"));
}

QString resolutionTextForFrame(const RawFrame &frame)
{
    if (!frame.valid || frame.width <= 0 || frame.height <= 0) {
        return QStringLiteral("Unavailable");
    }

    const int width = frame.hasActiveArea ? qMax(1, frame.activeRight - frame.activeLeft) : frame.width;
    const int height = frame.hasActiveArea ? qMax(1, frame.activeBottom - frame.activeTop) : frame.height;
    return QStringLiteral("%1 x %2").arg(width).arg(height);
}

QString bitDepthTextForFrame(const RawFrame &frame)
{
    return frame.valid && frame.bitsPerSample > 0
           ? QStringLiteral("%1-bit").arg(frame.bitsPerSample)
           : QStringLiteral("Unavailable");
}

quint64 clipSizeBytes(const QString &clipPath)
{
    const QFileInfo pathInfo(clipPath);
    if (pathInfo.isFile()) {
        return static_cast<quint64>(pathInfo.size());
    }

    quint64 totalBytes = 0;
    QDirIterator it(clipPath, QDir::Files | QDir::NoSymLinks, QDirIterator::Subdirectories);
    while (it.hasNext()) {
        it.next();
        totalBytes += static_cast<quint64>(it.fileInfo().size());
    }
    return totalBytes;
}

constexpr double kFallbackPlaybackFps = 24.0;
constexpr int kHistogramBinCount = 48;
constexpr int kHistogramTargetSamples = 16000;
constexpr int kAudioFeedIntervalMs = 12;
constexpr qint64 kAudioFeedMaxChunkBytes = 32768;

QVariantList zeroHistogramBins()
{
    QVariantList bins;
    bins.reserve(kHistogramBinCount);
    for (int i = 0; i < kHistogramBinCount; ++i) {
        bins.append(0.0);
    }
    return bins;
}

QVariantList buildHistogramBins(const RawFrame &frame)
{
    QVariantList bins = zeroHistogramBins();
    if (!frame.valid || frame.width <= 0 || frame.height <= 0 || frame.pixels.isEmpty()) {
        return bins;
    }

    const int left = frame.hasActiveArea ? qBound(0, frame.activeLeft, frame.width - 1) : 0;
    const int top = frame.hasActiveArea ? qBound(0, frame.activeTop, frame.height - 1) : 0;
    const int right = frame.hasActiveArea ? qBound(left + 1, frame.activeRight, frame.width) : frame.width;
    const int bottom = frame.hasActiveArea ? qBound(top + 1, frame.activeBottom, frame.height) : frame.height;
    const int sampleWidth = qMax(1, right - left);
    const int sampleHeight = qMax(1, bottom - top);
    const double totalPixels = static_cast<double>(sampleWidth) * static_cast<double>(sampleHeight);
    const int sampleStep = qMax(1, static_cast<int>(std::sqrt(totalPixels / static_cast<double>(kHistogramTargetSamples))));
    const float range = qMax(1.0f, frame.whiteLevel - frame.blackLevel);

    std::array<int, kHistogramBinCount> counts {};
    int maxCount = 0;

    for (int y = top; y < bottom; y += sampleStep) {
        const int rowOffset = y * frame.width;
        for (int x = left; x < right; x += sampleStep) {
            const float normalized = qBound(0.0f,
                                            (static_cast<float>(frame.pixels.at(rowOffset + x)) - frame.blackLevel) / range,
                                            1.0f);
            const int binIndex = qMin(kHistogramBinCount - 1,
                                      static_cast<int>(normalized * static_cast<float>(kHistogramBinCount - 1)));
            const int newCount = ++counts[binIndex];
            if (newCount > maxCount) {
                maxCount = newCount;
            }
        }
    }

    if (maxCount <= 0) {
        return bins;
    }

    bins.clear();
    bins.reserve(kHistogramBinCount);
    for (int count : counts) {
        const double normalized = static_cast<double>(count) / static_cast<double>(maxCount);
        bins.append(std::pow(normalized, 0.65));
    }

    return bins;
}

quint16 littleEndian16(const QByteArray &bytes, int offset)
{
    return qFromLittleEndian<quint16>(reinterpret_cast<const uchar *>(bytes.constData() + offset));
}

quint32 littleEndian32(const QByteArray &bytes, int offset)
{
    return qFromLittleEndian<quint32>(reinterpret_cast<const uchar *>(bytes.constData() + offset));
}
}

PlaybackController::PlaybackController(QObject *parent)
    : QObject(parent)
{
    m_histogramThreadPool.setMaxThreadCount(1);
    m_histogramThreadPool.setExpiryTimeout(-1);
    m_playbackTimer.setTimerType(Qt::PreciseTimer);
    connect(&m_playbackTimer, &QTimer::timeout, this, &PlaybackController::handlePlaybackTick);
    m_audioFeedTimer.setTimerType(Qt::PreciseTimer);
    m_audioFeedTimer.setInterval(kAudioFeedIntervalMs);
    connect(&m_audioFeedTimer, &QTimer::timeout, this, &PlaybackController::handleAudioFeedTick);
    connect(&m_audioProcess,
            qOverload<int, QProcess::ExitStatus>(&QProcess::finished),
            this,
            [this](int, QProcess::ExitStatus) {
                if (m_playing && audioPlaybackActive() && m_audioPendingBuffer.isEmpty())
                    stopAudioPlayback();
            });
    m_fps = kFallbackPlaybackFps;
    m_histogramBins = zeroHistogramBins();
    updateTimerInterval();
    setStatusText(QStringLiteral("Select a clip to preview."));
}

QString PlaybackController::currentClipName() const
{
    return m_currentClipName;
}

QString PlaybackController::currentClipPath() const
{
    return m_currentClipPath;
}

int PlaybackController::frameCount() const
{
    return m_frameFiles.size();
}

int PlaybackController::currentFrameIndex() const
{
    return m_currentFrameIndex;
}

bool PlaybackController::playing() const
{
    return m_playing;
}

double PlaybackController::fps() const
{
    return m_fps;
}

QString PlaybackController::currentFramePath() const
{
    if (m_currentFrameIndex < 0 || m_currentFrameIndex >= m_frameFiles.size())
        return {};

    return m_frameFiles.at(m_currentFrameIndex);
}

QString PlaybackController::statusText() const
{
    return m_statusText;
}

QVariantList PlaybackController::histogramBins() const
{
    return m_histogramBins;
}

QVariantMap PlaybackController::clipMetadata() const
{
    return m_clipMetadata;
}

QString PlaybackController::frameSource() const
{
    if (m_currentFrameIndex < 0 || m_currentFrameIndex >= m_frameFiles.size()) {
        return QStringLiteral("image://cdng/empty");
    }

    const QString encodedPath = QString::fromLatin1(m_frameFiles.at(m_currentFrameIndex).toUtf8().toBase64(QByteArray::Base64UrlEncoding));
    return QStringLiteral("image://cdng/frame?path64=%1&token=%2").arg(encodedPath).arg(m_frameToken);
}

QString PlaybackController::fastFrameSource() const
{
    if (m_currentFrameIndex < 0 || m_currentFrameIndex >= m_frameFiles.size()) {
        return QStringLiteral("image://cdngplay/empty");
    }

    const QString encodedPath = QString::fromLatin1(m_frameFiles.at(m_currentFrameIndex).toUtf8().toBase64(QByteArray::Base64UrlEncoding));
    return QStringLiteral("image://cdngplay/frame?path64=%1").arg(encodedPath);
}

quint64 PlaybackController::currentFrameToken() const
{
    return m_frameToken;
}

void PlaybackController::setSettingsBridge(SettingsBridge *settingsBridge)
{
    if (m_settingsBridge == settingsBridge)
        return;

    m_settingsBridge = settingsBridge;
    if (m_settingsBridge) {
        connect(m_settingsBridge, &SettingsBridge::audioOutputDeviceChanged, this, [this]() {
            if (m_playing && audioPlaybackActive())
                startAudioPlaybackForFrame(m_currentFrameIndex);
        });
    }
}

void PlaybackController::loadClip(const QString &clipPath)
{
    reloadFrameList(clipPath);
}

void PlaybackController::togglePlayback()
{
    if (m_frameFiles.isEmpty()) {
        setStatusText(QStringLiteral("No frames to play in the selected clip."));
        return;
    }

    setPlaying(!m_playing);
}

void PlaybackController::stop()
{
    setPlaying(false);
    if (m_frameFiles.isEmpty()) {
        resetHistogram();
        return;
    }

    m_currentFrameIndex = 0;
    ++m_frameToken;
    emit currentFrameChanged();
    updateHistogram();
    setStatusText(QStringLiteral("Stopped on frame 1 of %1.").arg(m_frameFiles.size()));
}

void PlaybackController::nextFrame()
{
    if (m_frameFiles.isEmpty()) {
        return;
    }

    m_currentFrameIndex = (m_currentFrameIndex + 1) % m_frameFiles.size();
    ++m_frameToken;
    emit currentFrameChanged();
    updateHistogram();
}

void PlaybackController::previousFrame()
{
    if (m_frameFiles.isEmpty()) {
        return;
    }

    m_currentFrameIndex = (m_currentFrameIndex - 1 + m_frameFiles.size()) % m_frameFiles.size();
    ++m_frameToken;
    emit currentFrameChanged();
    updateHistogram();
}

void PlaybackController::seekToFrame(int frameIndex)
{
    if (m_frameFiles.isEmpty()) {
        return;
    }

    const int clampedIndex = qBound(0, frameIndex, m_frameFiles.size() - 1);
    if (m_currentFrameIndex == clampedIndex) {
        return;
    }

    m_currentFrameIndex = clampedIndex;
    ++m_frameToken;
    emit currentFrameChanged();
    updateHistogram();

    if (m_playing && audioPlaybackActive())
        startAudioPlaybackForFrame(m_currentFrameIndex);

    if (!m_playing) {
        setStatusText(QStringLiteral("Paused %1 on frame %2 of %3.")
                          .arg(m_currentClipName)
                          .arg(m_currentFrameIndex + 1)
                          .arg(m_frameFiles.size()));
    }
}

void PlaybackController::setFps(double fps)
{
    const double clampedFps = qBound(1.0, fps, 60.0);
    if (qFuzzyCompare(m_fps, clampedFps)) {
        return;
    }

    m_fps = clampedFps;
    updateTimerInterval();
    emit fpsChanged();
    if (!m_frameFiles.isEmpty()) {
        updateClipMetadata();
    }
    if (m_playing && audioPlaybackActive())
        startAudioPlaybackForFrame(m_currentFrameIndex);
}

void PlaybackController::reloadFrameList(const QString &clipPath)
{
    const QFileInfo clipInfo(clipPath);
    const bool isSingleStill = clipInfo.isFile();
    const QDir clipDir(clipPath);
    m_audioClip = {};

    if (!isSingleStill && !clipDir.exists()) {
        m_currentClipName = clipInfo.fileName();
        m_currentClipPath = clipPath;
        m_frameFiles.clear();
        m_histogramCache.clear();
        m_currentFrameIndex = -1;
        setClipMetadata({});
        ++m_frameToken;
        emit clipChanged();
        emit currentFrameChanged();
        resetHistogram();
        setPlaying(false);
        setStatusText(QStringLiteral("Clip folder is not available: %1").arg(clipPath));
        return;
    }

    m_frameFiles.clear();
    if (isSingleStill) {
        m_frameFiles.append(clipInfo.absoluteFilePath());
    } else {
        QStringList frames = clipDir.entryList(dngNameFilters(), QDir::Files, QDir::Name);
        QCollator collator;
        collator.setNumericMode(true);
        std::sort(frames.begin(), frames.end(), [&collator](const QString &lhs, const QString &rhs) {
            return collator.compare(lhs, rhs) < 0;
        });

        m_frameFiles.reserve(frames.size());
        for (const QString &frameName : frames) {
            m_frameFiles.append(clipDir.absoluteFilePath(frameName));
        }
    }

    m_histogramCache.clear();
    m_currentClipName = isSingleStill && !clipInfo.completeBaseName().isEmpty()
        ? clipInfo.completeBaseName()
        : clipInfo.fileName();
    m_currentClipPath = clipPath;
    m_currentFrameIndex = m_frameFiles.isEmpty() ? -1 : 0;
    const double detectedFps = m_frameFiles.isEmpty() ? 0.0 : DngDecoder::detectFrameRate(m_frameFiles.first());
    setFps(detectedFps > 0.0 ? detectedFps : kFallbackPlaybackFps);
    discoverClipAudio();
    updateClipMetadata();
    emit clipChanged();
    setPlaying(false);

    if (m_frameFiles.isEmpty()) {
        ++m_frameToken;
        emit currentFrameChanged();
        resetHistogram();
        setStatusText(isSingleStill
                          ? QStringLiteral("Still file is not available: %1").arg(m_currentClipName)
                          : QStringLiteral("No DNG frames found in %1.").arg(m_currentClipName));
    } else {
        ++m_frameToken;
        emit currentFrameChanged();
        updateHistogram();
        if (isSingleStill) {
            setStatusText(QStringLiteral("Loaded still %1.").arg(m_currentClipName));
        } else if (detectedFps > 0.0) {
            setStatusText(QStringLiteral("Loaded %1 with %2 frame(s) at %3 fps.")
                              .arg(m_currentClipName)
                              .arg(m_frameFiles.size())
                              .arg(detectedFps, 0, 'f', 3));
        } else {
            setStatusText(QStringLiteral("Loaded %1 with %2 frame(s). Using %3 fps fallback.")
                              .arg(m_currentClipName)
                              .arg(m_frameFiles.size())
                              .arg(m_fps, 0, 'f', 3));
        }
    }
}

void PlaybackController::handlePlaybackTick()
{
    if (!m_playing)
        return;

    if (audioPlaybackActive()) {
        updateFrameFromPlaybackClock();
        return;
    }

    nextFrame();
}

void PlaybackController::handleAudioFeedTick()
{
    if (!m_playing
        || !audioPlaybackActive()
        || m_audioProcess.state() != QProcess::Running
        || !m_audioFile.isOpen()) {
        return;
    }

    if (!m_audioPendingBuffer.isEmpty()) {
        const qint64 written = writeAudioChunk(m_audioPendingBuffer);
        if (written > 0) {
            m_audioPendingBuffer.remove(0, static_cast<int>(written));
            m_audioAbsoluteBytesWritten += written;
        }

        if (!m_audioPendingBuffer.isEmpty())
            return;
    }

    const qint64 elapsedMs = m_audioClock.isValid() ? m_audioClock.elapsed() : 0;
    qint64 targetBytes = audioBytesForMs(m_audioStartOffsetMs + elapsedMs);
    qint64 bytesNeeded = targetBytes - m_audioAbsoluteBytesWritten;
    if (bytesNeeded <= 0)
        return;

    const int frameBytes = qMax(1, m_audioClip.bytesPerFrame());
    bytesNeeded = qMin(bytesNeeded, kAudioFeedMaxChunkBytes);
    bytesNeeded -= bytesNeeded % frameBytes;
    if (bytesNeeded <= 0)
        bytesNeeded = frameBytes;

    const qint64 fileEnd = m_audioClip.dataOffset + m_audioClip.dataSize;
    const qint64 remainingBytes = qMax<qint64>(0, fileEnd - m_audioFile.pos());
    if (remainingBytes <= 0)
        return;

    bytesNeeded = qMin(bytesNeeded, remainingBytes);
    QByteArray chunk = m_audioFile.read(bytesNeeded);
    if (chunk.isEmpty())
        return;

    const qint64 written = writeAudioChunk(chunk);
    if (written > 0)
        m_audioAbsoluteBytesWritten += written;

    if (written < chunk.size())
        m_audioPendingBuffer = chunk.mid(qMax<qint64>(0, written));
}

void PlaybackController::updateFrameFromPlaybackClock()
{
    if (!m_audioClock.isValid()) {
        nextFrame();
        return;
    }

    const qint64 clipDurationMs = qMax<qint64>(1, m_audioClip.durationMs);
    qint64 totalMs = m_audioStartOffsetMs + m_audioClock.elapsed();
    if (totalMs >= clipDurationMs) {
        const qint64 wrappedMs = totalMs % clipDurationMs;
        const int restartFrame = qBound(0,
                                        static_cast<int>(std::floor((static_cast<double>(wrappedMs) * m_fps) / 1000.0)),
                                        qMax(0, m_frameFiles.size() - 1));
        if (!startAudioPlaybackForFrame(restartFrame)) {
            setPlaying(false);
            return;
        }
        totalMs = m_audioStartOffsetMs + (m_audioClock.isValid() ? m_audioClock.elapsed() : 0);
    }

    const qint64 clampedMs = qBound<qint64>(0, totalMs, clipDurationMs - 1);
    const int newFrameIndex = qBound(0,
                                     static_cast<int>(std::floor((static_cast<double>(clampedMs) * m_fps) / 1000.0)),
                                     qMax(0, m_frameFiles.size() - 1));
    if (newFrameIndex == m_currentFrameIndex)
        return;

    m_currentFrameIndex = newFrameIndex;
    ++m_frameToken;
    emit currentFrameChanged();
    updateHistogram();
}

void PlaybackController::discoverClipAudio()
{
    stopAudioPlayback();
    m_audioClip = {};

    const QFileInfo pathInfo(m_currentClipPath);
    if (m_currentClipPath.isEmpty() || pathInfo.isFile())
        return;

    const QDir clipDir(m_currentClipPath);
    if (!clipDir.exists())
        return;

    QStringList candidates;
    const QString preferredNamedClip = clipDir.absoluteFilePath(clipDir.dirName() + QStringLiteral(".wav"));
    if (QFileInfo::exists(preferredNamedClip))
        candidates.append(preferredNamedClip);

    const QString legacyNamedClip = clipDir.absoluteFilePath(QStringLiteral("audio.wav"));
    if (QFileInfo::exists(legacyNamedClip) && !candidates.contains(legacyNamedClip))
        candidates.append(legacyNamedClip);

    const QStringList wavFiles = clipDir.entryList({QStringLiteral("*.wav"), QStringLiteral("*.WAV")},
                                                   QDir::Files,
                                                   QDir::Name);
    for (const QString &wavName : wavFiles) {
        const QString wavPath = clipDir.absoluteFilePath(wavName);
        if (!candidates.contains(wavPath))
            candidates.append(wavPath);
    }

    for (const QString &candidate : candidates) {
        const AudioClipInfo parsed = parseAudioClip(candidate);
        if (parsed.valid()) {
            m_audioClip = parsed;
            break;
        }
    }
}

PlaybackController::AudioClipInfo PlaybackController::parseAudioClip(const QString &filePath) const
{
    AudioClipInfo info;
    info.filePath = filePath;

    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly))
        return {};

    const QByteArray riffHeader = file.read(12);
    if (riffHeader.size() < 12
        || riffHeader.mid(0, 4) != "RIFF"
        || riffHeader.mid(8, 4) != "WAVE") {
        return {};
    }

    bool haveFmt = false;
    bool haveData = false;
    quint16 audioFormat = 0;

    while (file.pos() + 8 <= file.size()) {
        const QByteArray chunkHeader = file.read(8);
        if (chunkHeader.size() < 8)
            break;

        const QByteArray chunkId = chunkHeader.left(4);
        const quint32 chunkSize = littleEndian32(chunkHeader, 4);
        const qint64 chunkDataOffset = file.pos();

        if (chunkId == "fmt ") {
            const QByteArray fmtChunk = file.read(static_cast<qint64>(chunkSize));
            if (fmtChunk.size() >= 16) {
                audioFormat = littleEndian16(fmtChunk, 0);
                info.channels = littleEndian16(fmtChunk, 2);
                info.sampleRate = static_cast<int>(littleEndian32(fmtChunk, 4));
                info.bitsPerSample = littleEndian16(fmtChunk, 14);
                haveFmt = true;
            }
        } else if (chunkId == "data") {
            info.dataOffset = chunkDataOffset;
            info.dataSize = static_cast<qint64>(chunkSize);
            haveData = true;
        }

        const qint64 paddedChunkSize = static_cast<qint64>(chunkSize) + (chunkSize % 2u == 0u ? 0 : 1);
        if (!file.seek(chunkDataOffset + paddedChunkSize))
            break;
    }

    if (!haveFmt || !haveData || audioFormat != 1 || info.bitsPerSample != 16)
        return {};

    info.bytesPerSecond = static_cast<qint64>(info.sampleRate)
        * static_cast<qint64>(info.channels)
        * static_cast<qint64>(info.bitsPerSample / 8);
    if (info.bytesPerSecond <= 0)
        return {};

    info.durationMs = qMax<qint64>(1, (info.dataSize * 1000) / info.bytesPerSecond);
    return info.valid() ? info : AudioClipInfo {};
}

bool PlaybackController::startAudioPlaybackForFrame(int frameIndex)
{
    if (!audioPlaybackActive() || frameIndex < 0)
        return false;

    stopAudioPlayback();

    m_audioFile.setFileName(m_audioClip.filePath);
    if (!m_audioFile.open(QIODevice::ReadOnly))
        return false;

    const qint64 startOffsetMs = qBound<qint64>(0, audioOffsetMsForFrame(frameIndex), qMax<qint64>(0, m_audioClip.durationMs - 1));
    const qint64 startByteOffset = audioBytesForMs(startOffsetMs);
    if (!m_audioFile.seek(m_audioClip.dataOffset + startByteOffset)) {
        m_audioFile.close();
        return false;
    }

    const QString outputDevice = playbackOutputDevice();
    m_audioProcess.start(QStringLiteral("aplay"), {
        QStringLiteral("-q"),
        QStringLiteral("-D"), outputDevice,
        QStringLiteral("-f"), QStringLiteral("S16_LE"),
        QStringLiteral("-c"), QString::number(m_audioClip.channels),
        QStringLiteral("-r"), QString::number(m_audioClip.sampleRate),
        QStringLiteral("-t"), QStringLiteral("raw")
    });

    if (!m_audioProcess.waitForStarted(200)) {
        m_audioFile.close();
        return false;
    }

    m_audioStartOffsetMs = startOffsetMs;
    m_audioAbsoluteBytesWritten = startByteOffset;
    m_audioPendingBuffer.clear();
    m_audioClock.restart();
    m_audioFeedTimer.start();
    handleAudioFeedTick();
    return true;
}

void PlaybackController::stopAudioPlayback()
{
    m_audioFeedTimer.stop();
    m_audioPendingBuffer.clear();
    m_audioClock.invalidate();
    m_audioStartOffsetMs = 0;
    m_audioAbsoluteBytesWritten = 0;

    if (m_audioProcess.state() != QProcess::NotRunning) {
        m_audioProcess.closeWriteChannel();
        m_audioProcess.terminate();
        if (!m_audioProcess.waitForFinished(150))
            m_audioProcess.kill();
        m_audioProcess.waitForFinished(150);
    }

    if (m_audioFile.isOpen())
        m_audioFile.close();
}

QString PlaybackController::playbackOutputDevice() const
{
    const QString configuredDevice = m_settingsBridge
        ? normalizedPlaybackDevice(m_settingsBridge->audioOutputDevice())
        : QString();
    return configuredDevice.isEmpty() ? QStringLiteral("default") : configuredDevice;
}

QString PlaybackController::normalizedPlaybackDevice(const QString &deviceId) const
{
    const QString normalized = deviceId.trimmed();
    if (normalized.isEmpty())
        return {};

    if (normalized.startsWith(QStringLiteral("hw:"), Qt::CaseInsensitive))
        return QStringLiteral("plughw:%1").arg(normalized.mid(3));

    return normalized;
}

qint64 PlaybackController::audioOffsetMsForFrame(int frameIndex) const
{
    if (m_fps <= 0.0 || frameIndex <= 0)
        return 0;

    return qRound64((static_cast<double>(frameIndex) * 1000.0) / m_fps);
}

qint64 PlaybackController::audioBytesForMs(qint64 milliseconds) const
{
    if (!audioPlaybackActive() || milliseconds <= 0)
        return 0;

    qint64 bytes = (milliseconds * m_audioClip.bytesPerSecond) / 1000;
    const int frameBytes = qMax(1, m_audioClip.bytesPerFrame());
    bytes -= bytes % frameBytes;
    return qBound<qint64>(0, bytes, m_audioClip.dataSize);
}

qint64 PlaybackController::writeAudioChunk(const QByteArray &chunk)
{
    if (chunk.isEmpty() || m_audioProcess.state() != QProcess::Running)
        return 0;

    const qint64 written = m_audioProcess.write(chunk);
    return written > 0 ? written : 0;
}

bool PlaybackController::audioPlaybackActive() const
{
    return m_audioClip.valid();
}

void PlaybackController::updateTimerInterval()
{
    const int intervalMs = qMax(1, qRound(1000.0 / m_fps));
    m_playbackTimer.setInterval(intervalMs);
}

void PlaybackController::setPlaying(bool playing)
{
    if (m_playing == playing) {
        return;
    }

    m_playing = playing;
    if (m_playing) {
        if (audioPlaybackActive())
            startAudioPlaybackForFrame(m_currentFrameIndex);
        m_playbackTimer.start();
        setStatusText(QStringLiteral("Playing %1 at %2 fps.").arg(m_currentClipName).arg(m_fps, 0, 'f', 1));
    } else {
        m_playbackTimer.stop();
        stopAudioPlayback();
        updateHistogram();
        if (!m_currentClipName.isEmpty() && !m_frameFiles.isEmpty()) {
            setStatusText(QStringLiteral("Paused %1 on frame %2 of %3.")
                              .arg(m_currentClipName)
                              .arg(m_currentFrameIndex + 1)
                              .arg(m_frameFiles.size()));
        }
    }
    emit playingChanged();
}

void PlaybackController::setStatusText(const QString &statusText)
{
    if (m_statusText == statusText) {
        return;
    }

    m_statusText = statusText;
    emit statusTextChanged();
}

void PlaybackController::setClipMetadata(const QVariantMap &clipMetadata)
{
    if (m_clipMetadata == clipMetadata) {
        return;
    }

    m_clipMetadata = clipMetadata;
    emit clipMetadataChanged();
}

void PlaybackController::updateClipMetadata()
{
    if (m_currentClipPath.isEmpty() || m_frameFiles.isEmpty()) {
        setClipMetadata({});
        return;
    }

    const QFileInfo pathInfo(m_currentClipPath);
    const bool isSingleStill = pathInfo.isFile();
    const QString firstFramePath = m_frameFiles.first();
    RawFrame frame;
    DngDecoder::decodeFileInto(firstFramePath, frame);
    QVariantMap metadata;
    metadata.insert(QStringLiteral("type"), isSingleStill ? QStringLiteral("DNG still") : QStringLiteral("cDNG sequence"));
    metadata.insert(QStringLiteral("captured"), shotDateTimeForFrame(firstFramePath));
    metadata.insert(QStringLiteral("resolution"), resolutionTextForFrame(frame));
    metadata.insert(QStringLiteral("bitDepth"), bitDepthTextForFrame(frame));
    metadata.insert(QStringLiteral("frameRate"),
                    isSingleStill ? QStringLiteral("Single frame")
                                  : QStringLiteral("%1 fps").arg(m_fps, 0, 'f', 3));
    metadata.insert(QStringLiteral("duration"),
                    isSingleStill ? QStringLiteral("Still frame")
                                  : formatDurationText(m_frameFiles.size(), m_fps));
    metadata.insert(QStringLiteral("frames"), QString::number(m_frameFiles.size()));
    metadata.insert(QStringLiteral("clipSize"), formatByteSize(clipSizeBytes(m_currentClipPath)));
    metadata.insert(QStringLiteral("path"), m_currentClipPath);
    setClipMetadata(metadata);
}

void PlaybackController::updateHistogram()
{
    if (m_currentFrameIndex < 0 || m_currentFrameIndex >= m_frameFiles.size()) {
        resetHistogram();
        return;
    }

    const QString framePath = m_frameFiles.at(m_currentFrameIndex);
    const auto cached = m_histogramCache.constFind(framePath);
    if (cached != m_histogramCache.constEnd()) {
        if (m_histogramBins != cached.value()) {
            m_histogramBins = cached.value();
            emit histogramChanged();
        }
        return;
    }

    m_histogramRequestedPath = framePath;
    if (m_histogramRequestInFlight)
        return;

    m_histogramRequestInFlight = true;
    const QString requestedPath = framePath;
    m_histogramThreadPool.start(QRunnable::create([this, requestedPath]() {
        QVariantList bins = DngDecoder::decodeHistogramBins(requestedPath,
                                                            kHistogramBinCount,
                                                            kHistogramTargetSamples);
        if (bins.isEmpty()) {
            static thread_local RawFrame histogramScratchFrame;
            DngDecoder::decodeFileInto(requestedPath, histogramScratchFrame);
            bins = buildHistogramBins(histogramScratchFrame);
        }
        QMetaObject::invokeMethod(this, [this, requestedPath, bins]() {
            m_histogramCache.insert(requestedPath, bins);
            m_histogramRequestInFlight = false;

            if (currentFramePath() == requestedPath && m_histogramBins != bins) {
                m_histogramBins = bins;
                emit histogramChanged();
            }

            if (!m_histogramRequestedPath.isEmpty() && m_histogramRequestedPath != requestedPath)
                updateHistogram();
        }, Qt::QueuedConnection);
    }));
}

void PlaybackController::resetHistogram()
{
    const QVariantList bins = zeroHistogramBins();
    if (m_histogramBins != bins) {
        m_histogramBins = bins;
        emit histogramChanged();
    }
}
