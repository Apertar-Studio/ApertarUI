#include "SettingsBridge.hpp"
#include "ApertarControlBridge.hpp"

#include <algorithm>
#include <QDateTime>
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QJsonArray>
#include <QJsonDocument>
#include <QSaveFile>
#include <QStandardPaths>

namespace {

QString stringValue(const QJsonObject &object, const char *key, const QString &fallback = QString())
{
    const QJsonValue value = object.value(QLatin1String(key));
    return value.isString() ? value.toString() : fallback;
}

bool boolValue(const QJsonObject &object, const char *key, bool fallback)
{
    const QJsonValue value = object.value(QLatin1String(key));
    return value.isBool() ? value.toBool() : fallback;
}

int intValue(const QJsonObject &object, const char *key, int fallback)
{
    const QJsonValue value = object.value(QLatin1String(key));
    return value.isDouble() ? value.toInt(fallback) : fallback;
}

double doubleValue(const QJsonObject &object, const char *key, double fallback)
{
    const QJsonValue value = object.value(QLatin1String(key));
    return value.isDouble() ? value.toDouble(fallback) : fallback;
}

double clampCameraControlsOpacity(double value)
{
    return qBound(0.15, value, 1.0);
}

QString normalizeCameraControlsMode(const QString &value)
{
    return value.trimmed().compare(QStringLiteral("Dark"), Qt::CaseInsensitive) == 0
        ? QStringLiteral("Dark")
        : QStringLiteral("Light");
}

QStringList stringListValue(const QJsonObject &object, const char *key, const QStringList &fallback = {})
{
    const QJsonValue value = object.value(QLatin1String(key));
    if (!value.isArray())
        return fallback;

    QStringList out;
    const QJsonArray values = value.toArray();
    out.reserve(values.size());
    for (const QJsonValue &entry : values) {
        if (entry.isString())
            out.push_back(entry.toString());
    }
    return out;
}

QStringList parseSimpleStringList(const QString &value)
{
    const QString trimmed = value.trimmed();
    if (trimmed.isEmpty())
        return {};

    const QChar delimiter = trimmed.contains(QLatin1Char('|')) ? QLatin1Char('|') : QLatin1Char(',');
    QStringList parts = trimmed.split(delimiter, Qt::SkipEmptyParts);
    QStringList out;
    out.reserve(parts.size());
    for (QString part : parts) {
        part = part.trimmed();
        if (part.size() >= 2 && part.startsWith(QLatin1Char('"')) && part.endsWith(QLatin1Char('"')))
            part = part.mid(1, part.size() - 2).trimmed();
        if (!part.isEmpty())
            out.push_back(part);
    }
    return out;
}

QStringList settingsListValue(const QVariant &value)
{
    if (!value.isValid())
        return {};

    if (value.metaType().id() == QMetaType::QStringList)
        return value.toStringList();

    return parseSimpleStringList(value.toString());
}

QString normalizePhotoFormat(const QString &value)
{
    const QString trimmed = value.trimmed();
    const QString normalized = trimmed.toLower();
    if (normalized == QStringLiteral("jpg") || normalized == QStringLiteral("jpeg"))
        return QStringLiteral("JPEG");
    if (normalized == QStringLiteral("png"))
        return QStringLiteral("PNG");
    if (normalized == QStringLiteral("tif") || normalized == QStringLiteral("tiff"))
        return QStringLiteral("TIFF");
    if (normalized == QStringLiteral("dng+jpeg") ||
        normalized == QStringLiteral("dng + jpeg") ||
        normalized == QStringLiteral("dng_jpeg") ||
        normalized == QStringLiteral("dng-jpeg")) {
        return QStringLiteral("DNG + JPEG");
    }
    if (normalized == QStringLiteral("dng+png") ||
        normalized == QStringLiteral("dng + png") ||
        normalized == QStringLiteral("dng_png") ||
        normalized == QStringLiteral("dng-png")) {
        return QStringLiteral("DNG + PNG");
    }
    if (normalized == QStringLiteral("dng+tif") ||
        normalized == QStringLiteral("dng + tif") ||
        normalized == QStringLiteral("dng_tif") ||
        normalized == QStringLiteral("dng-tif") ||
        normalized == QStringLiteral("dng+tiff") ||
        normalized == QStringLiteral("dng + tiff") ||
        normalized == QStringLiteral("dng_tiff") ||
        normalized == QStringLiteral("dng-tiff")) {
        return QStringLiteral("DNG + TIFF");
    }
    return QStringLiteral("DNG");
}

}

SettingsBridge::SettingsBridge(QObject *parent)
    : QObject(parent),
      m_settings("CinePi", "UI")
{
    auto normalizeExternalMonitorMode = [](const QString &value) {
        return value == QStringLiteral("Overlay Feed")
               || value == QStringLiteral("Assist Feed")
            ? QStringLiteral("Assist Feed")
            : QStringLiteral("Clean Feed");
    };
    auto normalizeExternalMonitorInfoOverlay = [](const QString &value) {
        return value == QStringLiteral("Off")
            ? QStringLiteral("Off")
            : QStringLiteral("On");
    };
    auto normalizeExternalMonitorOrientation = [](const QString &value) {
        if (value == QStringLiteral("Upside Down")) {
            return value;
        }
        return QStringLiteral("Landscape");
    };
    auto normalizeUiOrientation = [](const QString &value) {
        if (value == QStringLiteral("Left Side")
            || value == QStringLiteral("Right Side")
            || value == QStringLiteral("Upside Down")) {
            return value;
        }
        if (value == QStringLiteral("Left"))
            return QStringLiteral("Right Side");
        if (value == QStringLiteral("Right"))
            return QStringLiteral("Left Side");
        return QStringLiteral("Landscape");
    };
    auto normalizeAudioDeviceSelection = [](const QString &value) {
        return value.trimmed().compare(QStringLiteral("Auto"), Qt::CaseInsensitive) == 0
            ? QString()
            : value.trimmed();
    };

    m_zebraEnabled = m_settings.value("zebraEnabled", false).toBool();
    m_zebraThreshold = m_settings.value("zebraThreshold", 0.70).toFloat();

    m_focusPeakingEnabled = m_settings.value("focusPeakingEnabled", false).toBool();
    m_focusPeakingThreshold = m_settings.value("focusPeakingThreshold", 0.04).toFloat();
    m_focusPeakingColor = m_settings.value("focusPeakingColor", "Red").toString();

    m_grayscaleEnabled = m_settings.value("grayscaleEnabled", false).toBool();
    m_smpteEnabled = m_settings.value("smpteEnabled", false).toBool();
    m_anamorphicDesqueezeEnabled = m_settings.value("anamorphicDesqueezeEnabled", false).toBool();
    m_anamorphicRatio = m_settings.value("anamorphicRatio", "1.33x").toString();

    m_falseColorEnabled = m_settings.value("falseColorEnabled", false).toBool();
    m_falseColorMode = m_settings.value("falseColorMode", 0).toInt();

    m_guidesEnabled = m_settings.value("guidesEnabled", true).toBool();
    m_guidesType = m_settings.value("guidesType", "Thirds").toString();
    m_guidesThickness = qBound(1, m_settings.value("guidesThickness", 1).toInt(), 4);

    m_centerMarkerEnabled = m_settings.value("centerMarkerEnabled", true).toBool();
    m_centerMarkerType = m_settings.value("centerMarkerType", "Circle/Dot").toString();
    m_uiOrientation = normalizeUiOrientation(
        m_settings.value("uiOrientation", "Landscape").toString());
    m_cameraControlsOpacity = clampCameraControlsOpacity(
        m_settings.value("cameraControlsOpacity", 1.0).toDouble());
    m_cameraControlsMode = normalizeCameraControlsMode(
        m_settings.value("cameraControlsMode", "Light").toString());
    m_externalMonitorEnabled = m_settings.value("externalMonitorEnabled", false).toBool();
    m_externalMonitorMode = normalizeExternalMonitorMode(
        m_settings.value("externalMonitorMode", "Clean Feed").toString());
    m_externalMonitorInfoOverlay = normalizeExternalMonitorInfoOverlay(
        m_settings.value("externalMonitorInfoOverlay", "On").toString());
    m_externalMonitorOrientation = normalizeExternalMonitorOrientation(
        m_settings.value("externalMonitorOrientation", "Landscape").toString());
    m_dateTimeOverlayEnabled = m_settings.value("dateTimeOverlayEnabled", false).toBool();
    m_timecodeMode = m_settings.value("timecodeMode", "Free Run").toString();
    m_photoModeEnabled = m_settings.value("photoModeEnabled", false).toBool();
    m_photoTimer = m_settings.value("photoTimer", "Off").toString();
    m_photoBurst = m_settings.value("photoBurst", "Single").toString();
    m_photoFormat = normalizePhotoFormat(m_settings.value("photoFormat", "DNG").toString());
    m_recordAudioEnabled = m_settings.value("recordAudioEnabled", false).toBool();
    m_liveAudioMonitoringEnabled = m_settings.value("liveAudioMonitoringEnabled", true).toBool();
    m_audioMeterEnabled = m_settings.value("audioMeterEnabled", false).toBool();
    m_audioInputDevice = normalizeAudioDeviceSelection(
        m_settings.value("audioInputDevice", "").toString());
    m_audioOutputDevice = normalizeAudioDeviceSelection(
        m_settings.value("audioOutputDevice", "").toString());
    m_inputVolume = m_settings.value("inputVolume", 60).toInt();
    m_headphoneVolume = m_settings.value("headphoneVolume", 55).toInt();
    m_batteryCapacity = m_settings.value("batteryCapacity", "150Wh").toString();
    m_customBatteryWh = m_settings.value("customBatteryWh", 150).toInt();
    m_sleepMode = m_settings.value("sleepMode", "Off").toString();
    m_monitoringOrder = settingsListValue(m_settings.value("monitoringOrder"));
    m_recordOrder = settingsListValue(m_settings.value("recordOrder"));
    m_audioOrder = settingsListValue(m_settings.value("audioOrder"));
    m_powerOrder = settingsListValue(m_settings.value("powerOrder"));
    m_systemOrder = settingsListValue(m_settings.value("systemOrder"));
    m_wifiOrder = settingsListValue(m_settings.value("wifiOrder"));
    m_infoOrder = settingsListValue(m_settings.value("infoOrder"));
    m_sidebarOrder = settingsListValue(m_settings.value("sidebarOrder"));
    m_favoritesOrder = settingsListValue(m_settings.value("favoritesOrder"));
    reloadPresetNames();
    m_presetDirectorySignature = currentPresetDirectorySignature();

    m_settingsFilePath = m_settings.fileName();
    updateSettingsFileState();
    m_externalSettingsPollTimer.setInterval(700);
    connect(&m_externalSettingsPollTimer, &QTimer::timeout,
            this, &SettingsBridge::pollExternalSettings);
    m_externalSettingsPollTimer.start();
}

void SettingsBridge::setControlBridge(ApertarControlBridge *controlBridge)
{
    m_controlBridge = controlBridge;
}

void SettingsBridge::setDefaultCameraControlsOpacity(double value)
{
    if (m_settings.contains(QStringLiteral("cameraControlsOpacity")))
        return;

    const double clamped = clampCameraControlsOpacity(value);
    if (qFuzzyCompare(m_cameraControlsOpacity + 1.0, clamped + 1.0))
        return;

    m_cameraControlsOpacity = clamped;
    emit cameraControlsOpacityChanged();
}

void SettingsBridge::updateSettingsFileState()
{
    const QFileInfo info(m_settingsFilePath);
    if (!info.exists()) {
        m_settingsFileLastModified = QDateTime();
        m_settingsFileSize = -1;
        return;
    }

    m_settingsFileLastModified = info.lastModified();
    m_settingsFileSize = info.size();
}

void SettingsBridge::pollExternalSettings()
{
    if (m_externalSettingsSyncing || m_settingsFilePath.isEmpty())
        return;

    const QStringList presetDirectorySignature = currentPresetDirectorySignature();
    if (presetDirectorySignature != m_presetDirectorySignature)
        reloadPresetNames();

    const QFileInfo info(m_settingsFilePath);
    const QDateTime lastModified = info.exists() ? info.lastModified() : QDateTime();
    const qint64 fileSize = info.exists() ? info.size() : -1;
    if (lastModified == m_settingsFileLastModified && fileSize == m_settingsFileSize)
        return;

    m_externalSettingsSyncing = true;
    m_settings.sync();

    setZebraEnabled(m_settings.value(QStringLiteral("zebraEnabled"), m_zebraEnabled).toBool());
    setZebraThreshold(static_cast<float>(m_settings.value(QStringLiteral("zebraThreshold"), m_zebraThreshold).toDouble()));
    setFocusPeakingEnabled(m_settings.value(QStringLiteral("focusPeakingEnabled"), m_focusPeakingEnabled).toBool());
    setFocusPeakingThreshold(static_cast<float>(m_settings.value(QStringLiteral("focusPeakingThreshold"), m_focusPeakingThreshold).toDouble()));
    setFocusPeakingColor(m_settings.value(QStringLiteral("focusPeakingColor"), m_focusPeakingColor).toString());
    setAnamorphicDesqueezeEnabled(m_settings.value(QStringLiteral("anamorphicDesqueezeEnabled"), m_anamorphicDesqueezeEnabled).toBool());
    setAnamorphicRatio(m_settings.value(QStringLiteral("anamorphicRatio"), m_anamorphicRatio).toString());
    setFalseColorEnabled(m_settings.value(QStringLiteral("falseColorEnabled"), m_falseColorEnabled).toBool());
    setFalseColorMode(m_settings.value(QStringLiteral("falseColorMode"), m_falseColorMode).toInt());
    setGuidesEnabled(m_settings.value(QStringLiteral("guidesEnabled"), m_guidesEnabled).toBool());
    setGuidesType(m_settings.value(QStringLiteral("guidesType"), m_guidesType).toString());
    setGuidesThickness(m_settings.value(QStringLiteral("guidesThickness"), m_guidesThickness).toInt());
    setCenterMarkerEnabled(m_settings.value(QStringLiteral("centerMarkerEnabled"), m_centerMarkerEnabled).toBool());
    setCenterMarkerType(m_settings.value(QStringLiteral("centerMarkerType"), m_centerMarkerType).toString());
    setGrayscaleEnabled(m_settings.value(QStringLiteral("grayscaleEnabled"), m_grayscaleEnabled).toBool());
    setSmpteEnabled(m_settings.value(QStringLiteral("smpteEnabled"), m_smpteEnabled).toBool());
    setCameraControlsOpacity(m_settings.value(QStringLiteral("cameraControlsOpacity"), m_cameraControlsOpacity).toDouble());
    setCameraControlsMode(m_settings.value(QStringLiteral("cameraControlsMode"), m_cameraControlsMode).toString());
    setExternalMonitorEnabled(m_settings.value(QStringLiteral("externalMonitorEnabled"), m_externalMonitorEnabled).toBool());
    setExternalMonitorMode(m_settings.value(QStringLiteral("externalMonitorMode"), m_externalMonitorMode).toString());
    setExternalMonitorInfoOverlay(m_settings.value(QStringLiteral("externalMonitorInfoOverlay"), m_externalMonitorInfoOverlay).toString());
    setExternalMonitorOrientation(m_settings.value(QStringLiteral("externalMonitorOrientation"), m_externalMonitorOrientation).toString());
    setDateTimeOverlayEnabled(m_settings.value(QStringLiteral("dateTimeOverlayEnabled"), m_dateTimeOverlayEnabled).toBool());
    setPhotoModeEnabled(m_settings.value(QStringLiteral("photoModeEnabled"), m_photoModeEnabled).toBool());
    setPhotoTimer(m_settings.value(QStringLiteral("photoTimer"), m_photoTimer).toString());
    setPhotoBurst(m_settings.value(QStringLiteral("photoBurst"), m_photoBurst).toString());
    setPhotoFormat(m_settings.value(QStringLiteral("photoFormat"), m_photoFormat).toString());
    setUiOrientation(m_settings.value(QStringLiteral("uiOrientation"), m_uiOrientation).toString());
    setRecordAudioEnabled(m_settings.value(QStringLiteral("recordAudioEnabled"), m_recordAudioEnabled).toBool());
    setLiveAudioMonitoringEnabled(m_settings.value(QStringLiteral("liveAudioMonitoringEnabled"), m_liveAudioMonitoringEnabled).toBool());
    setAudioMeterEnabled(m_settings.value(QStringLiteral("audioMeterEnabled"), m_audioMeterEnabled).toBool());
    setAudioInputDevice(m_settings.value(QStringLiteral("audioInputDevice"), m_audioInputDevice).toString());
    setAudioOutputDevice(m_settings.value(QStringLiteral("audioOutputDevice"), m_audioOutputDevice).toString());
    setInputVolume(m_settings.value(QStringLiteral("inputVolume"), m_inputVolume).toInt());
    setHeadphoneVolume(m_settings.value(QStringLiteral("headphoneVolume"), m_headphoneVolume).toInt());
    setBatteryCapacity(m_settings.value(QStringLiteral("batteryCapacity"), m_batteryCapacity).toString());
    setCustomBatteryWh(m_settings.value(QStringLiteral("customBatteryWh"), m_customBatteryWh).toInt());
    setSleepMode(m_settings.value(QStringLiteral("sleepMode"), m_sleepMode).toString());
    setFavoritesOrder(settingsListValue(m_settings.value(QStringLiteral("favoritesOrder"))));

    QString timecodeMode = m_settings.value(QStringLiteral("timecodeMode"), m_timecodeMode).toString().trimmed();
    if (timecodeMode.compare(QStringLiteral("Rec Run"), Qt::CaseInsensitive) == 0
        || timecodeMode.compare(QStringLiteral("rec_run"), Qt::CaseInsensitive) == 0) {
        timecodeMode = QStringLiteral("Rec Run");
    } else {
        timecodeMode = QStringLiteral("Free Run");
    }
    setTimecodeMode(timecodeMode);

    m_settings.sync();
    updateSettingsFileState();
    m_externalSettingsSyncing = false;
}

bool SettingsBridge::zebraEnabled() const
{
    return m_zebraEnabled;
}

void SettingsBridge::setZebraEnabled(bool value)
{
    if (m_zebraEnabled == value)
        return;

    m_zebraEnabled = value;
    m_settings.setValue("zebraEnabled", value);
    m_settings.sync();
    updateSettingsFileState();
    emit zebraEnabledChanged();
}

float SettingsBridge::zebraThreshold() const
{
    return m_zebraThreshold;
}

void SettingsBridge::setZebraThreshold(float value)
{
    if (qFuzzyCompare(m_zebraThreshold, value))
        return;

    m_zebraThreshold = value;
    m_settings.setValue("zebraThreshold", value);
    emit zebraThresholdChanged();
}

bool SettingsBridge::focusPeakingEnabled() const
{
    return m_focusPeakingEnabled;
}

void SettingsBridge::setFocusPeakingEnabled(bool value)
{
    if (m_focusPeakingEnabled == value)
        return;

    m_focusPeakingEnabled = value;
    m_settings.setValue("focusPeakingEnabled", value);
    m_settings.sync();
    updateSettingsFileState();
    emit focusPeakingEnabledChanged();
}

float SettingsBridge::focusPeakingThreshold() const
{
    return m_focusPeakingThreshold;
}

void SettingsBridge::setFocusPeakingThreshold(float value)
{
    if (qFuzzyCompare(m_focusPeakingThreshold, value))
        return;

    m_focusPeakingThreshold = value;
    m_settings.setValue("focusPeakingThreshold", value);
    emit focusPeakingThresholdChanged();
}

QString SettingsBridge::focusPeakingColor() const
{
    return m_focusPeakingColor;
}

void SettingsBridge::setFocusPeakingColor(const QString &value)
{
    if (m_focusPeakingColor == value)
        return;

    m_focusPeakingColor = value;
    m_settings.setValue("focusPeakingColor", value);
    emit focusPeakingColorChanged();
}

bool SettingsBridge::grayscaleEnabled() const
{
    return m_grayscaleEnabled;
}

void SettingsBridge::setGrayscaleEnabled(bool value)
{
    if (m_grayscaleEnabled == value)
        return;

    m_grayscaleEnabled = value;
    m_settings.setValue("grayscaleEnabled", value);
    m_settings.sync();
    updateSettingsFileState();
    emit grayscaleEnabledChanged();
}

bool SettingsBridge::smpteEnabled() const
{
    return m_smpteEnabled;
}

void SettingsBridge::setSmpteEnabled(bool value)
{
    if (m_smpteEnabled == value)
        return;

    m_smpteEnabled = value;
    m_settings.setValue("smpteEnabled", value);
    m_settings.sync();
    updateSettingsFileState();
    emit smpteEnabledChanged();
}

bool SettingsBridge::anamorphicDesqueezeEnabled() const
{
    return m_anamorphicDesqueezeEnabled;
}

void SettingsBridge::setAnamorphicDesqueezeEnabled(bool value)
{
    if (m_anamorphicDesqueezeEnabled == value)
        return;

    m_anamorphicDesqueezeEnabled = value;
    m_settings.setValue("anamorphicDesqueezeEnabled", value);
    emit anamorphicDesqueezeEnabledChanged();
}

QString SettingsBridge::anamorphicRatio() const
{
    return m_anamorphicRatio;
}

void SettingsBridge::setAnamorphicRatio(const QString &value)
{
    if (m_anamorphicRatio == value)
        return;

    m_anamorphicRatio = value;
    m_settings.setValue("anamorphicRatio", value);
    emit anamorphicRatioChanged();
}

bool SettingsBridge::falseColorEnabled() const
{
    return m_falseColorEnabled;
}

void SettingsBridge::setFalseColorEnabled(bool value)
{
    if (m_falseColorEnabled == value)
        return;

    m_falseColorEnabled = value;
    m_settings.setValue("falseColorEnabled", value);
    m_settings.sync();
    updateSettingsFileState();
    emit falseColorEnabledChanged();
}

int SettingsBridge::falseColorMode() const
{
    return m_falseColorMode;
}

void SettingsBridge::setFalseColorMode(int value)
{
    if (m_falseColorMode == value)
        return;

    m_falseColorMode = value;
    m_settings.setValue("falseColorMode", value);
    emit falseColorModeChanged();
}

bool SettingsBridge::guidesEnabled() const
{
    return m_guidesEnabled;
}

void SettingsBridge::setGuidesEnabled(bool value)
{
    if (m_guidesEnabled == value)
        return;

    m_guidesEnabled = value;
    m_settings.setValue("guidesEnabled", value);
    m_settings.sync();
    updateSettingsFileState();
    emit guidesEnabledChanged();
}

QString SettingsBridge::guidesType() const
{
    return m_guidesType;
}

void SettingsBridge::setGuidesType(const QString &value)
{
    if (m_guidesType == value)
        return;

    m_guidesType = value;
    m_settings.setValue("guidesType", value);
    emit guidesTypeChanged();
}

int SettingsBridge::guidesThickness() const
{
    return m_guidesThickness;
}

void SettingsBridge::setGuidesThickness(int value)
{
    const int clamped = qBound(1, value, 4);
    if (m_guidesThickness == clamped)
        return;

    m_guidesThickness = clamped;
    m_settings.setValue("guidesThickness", clamped);
    emit guidesThicknessChanged();
}

bool SettingsBridge::centerMarkerEnabled() const
{
    return m_centerMarkerEnabled;
}

void SettingsBridge::setCenterMarkerEnabled(bool value)
{
    if (m_centerMarkerEnabled == value)
        return;

    m_centerMarkerEnabled = value;
    m_settings.setValue("centerMarkerEnabled", value);
    m_settings.sync();
    updateSettingsFileState();
    emit centerMarkerEnabledChanged();
}

QString SettingsBridge::centerMarkerType() const
{
    return m_centerMarkerType;
}

void SettingsBridge::setCenterMarkerType(const QString &value)
{
    if (m_centerMarkerType == value)
        return;

    m_centerMarkerType = value;
    m_settings.setValue("centerMarkerType", value);
    emit centerMarkerTypeChanged();
}

QString SettingsBridge::uiOrientation() const
{
    return m_uiOrientation;
}

void SettingsBridge::setUiOrientation(const QString &value)
{
    QString normalized = QStringLiteral("Landscape");
    if (value == QStringLiteral("Left Side")
        || value == QStringLiteral("Right Side")
        || value == QStringLiteral("Upside Down")) {
        normalized = value;
    } else if (value == QStringLiteral("Left")) {
        normalized = QStringLiteral("Right Side");
    } else if (value == QStringLiteral("Right")) {
        normalized = QStringLiteral("Left Side");
    }

    if (m_uiOrientation == normalized)
        return;

    m_uiOrientation = normalized;
    m_settings.setValue("uiOrientation", normalized);
    m_settings.sync();
    updateSettingsFileState();
    emit uiOrientationChanged();
}

double SettingsBridge::cameraControlsOpacity() const
{
    return m_cameraControlsOpacity;
}

void SettingsBridge::setCameraControlsOpacity(double value)
{
    const double clamped = clampCameraControlsOpacity(value);
    if (qFuzzyCompare(m_cameraControlsOpacity + 1.0, clamped + 1.0))
        return;

    m_cameraControlsOpacity = clamped;
    m_settings.setValue("cameraControlsOpacity", clamped);
    m_settings.sync();
    updateSettingsFileState();
    emit cameraControlsOpacityChanged();
}

QString SettingsBridge::cameraControlsMode() const
{
    return m_cameraControlsMode;
}

void SettingsBridge::setCameraControlsMode(const QString &value)
{
    const QString normalized = normalizeCameraControlsMode(value);
    if (m_cameraControlsMode == normalized)
        return;

    m_cameraControlsMode = normalized;
    m_settings.setValue("cameraControlsMode", normalized);
    m_settings.sync();
    updateSettingsFileState();
    emit cameraControlsModeChanged();
}

bool SettingsBridge::externalMonitorEnabled() const
{
    return m_externalMonitorEnabled;
}

void SettingsBridge::setExternalMonitorEnabled(bool value)
{
    if (m_externalMonitorEnabled == value)
        return;

    m_externalMonitorEnabled = value;
    m_settings.setValue("externalMonitorEnabled", value);
    emit externalMonitorEnabledChanged();
}

QString SettingsBridge::externalMonitorMode() const
{
    return m_externalMonitorMode;
}

void SettingsBridge::setExternalMonitorMode(const QString &value)
{
    const QString normalized = (value == QStringLiteral("Overlay Feed")
                                || value == QStringLiteral("Assist Feed"))
        ? QStringLiteral("Assist Feed")
        : QStringLiteral("Clean Feed");

    if (m_externalMonitorMode == normalized)
        return;

    m_externalMonitorMode = normalized;
    m_settings.setValue("externalMonitorMode", normalized);
    emit externalMonitorModeChanged();
}

QString SettingsBridge::externalMonitorInfoOverlay() const
{
    return m_externalMonitorInfoOverlay;
}

void SettingsBridge::setExternalMonitorInfoOverlay(const QString &value)
{
    const QString normalized = value == QStringLiteral("Off")
        ? QStringLiteral("Off")
        : QStringLiteral("On");

    if (m_externalMonitorInfoOverlay == normalized)
        return;

    m_externalMonitorInfoOverlay = normalized;
    m_settings.setValue("externalMonitorInfoOverlay", normalized);
    emit externalMonitorInfoOverlayChanged();
}

QString SettingsBridge::externalMonitorOrientation() const
{
    return m_externalMonitorOrientation;
}

void SettingsBridge::setExternalMonitorOrientation(const QString &value)
{
    QString normalized = QStringLiteral("Landscape");
    if (value == QStringLiteral("Upside Down")) {
        normalized = value;
    }

    if (m_externalMonitorOrientation == normalized)
        return;

    m_externalMonitorOrientation = normalized;
    m_settings.setValue("externalMonitorOrientation", normalized);
    emit externalMonitorOrientationChanged();
}

bool SettingsBridge::dateTimeOverlayEnabled() const
{
    return m_dateTimeOverlayEnabled;
}

void SettingsBridge::setDateTimeOverlayEnabled(bool value)
{
    if (m_dateTimeOverlayEnabled == value)
        return;

    m_dateTimeOverlayEnabled = value;
    m_settings.setValue("dateTimeOverlayEnabled", value);
    m_settings.sync();
    updateSettingsFileState();
    emit dateTimeOverlayEnabledChanged();
}

QString SettingsBridge::timecodeMode() const
{
    return m_timecodeMode;
}

void SettingsBridge::setTimecodeMode(const QString &value)
{
    if (m_timecodeMode == value)
        return;

    m_timecodeMode = value;
    m_settings.setValue("timecodeMode", value);
    m_settings.sync();
    updateSettingsFileState();
    emit timecodeModeChanged();
}

bool SettingsBridge::photoModeEnabled() const
{
    return m_photoModeEnabled;
}

void SettingsBridge::setPhotoModeEnabled(bool value)
{
    if (m_photoModeEnabled == value)
        return;

    m_photoModeEnabled = value;
    m_settings.setValue("photoModeEnabled", value);
    emit photoModeEnabledChanged();
}

QString SettingsBridge::photoTimer() const
{
    return m_photoTimer;
}

void SettingsBridge::setPhotoTimer(const QString &value)
{
    if (m_photoTimer == value)
        return;

    m_photoTimer = value;
    m_settings.setValue("photoTimer", value);
    emit photoTimerChanged();
}

QString SettingsBridge::photoBurst() const
{
    return m_photoBurst;
}

void SettingsBridge::setPhotoBurst(const QString &value)
{
    if (m_photoBurst == value)
        return;

    m_photoBurst = value;
    m_settings.setValue("photoBurst", value);
    emit photoBurstChanged();
}

QString SettingsBridge::photoFormat() const
{
    return m_photoFormat;
}

void SettingsBridge::setPhotoFormat(const QString &value)
{
    const QString normalized = normalizePhotoFormat(value);
    if (m_photoFormat == normalized)
        return;

    m_photoFormat = normalized;
    m_settings.setValue("photoFormat", normalized);
    emit photoFormatChanged();
}

bool SettingsBridge::recordAudioEnabled() const
{
    return m_recordAudioEnabled;
}

void SettingsBridge::setRecordAudioEnabled(bool value)
{
    if (m_recordAudioEnabled == value)
        return;

    m_recordAudioEnabled = value;
    m_settings.setValue("recordAudioEnabled", value);
    m_settings.sync();
    emit recordAudioEnabledChanged();
}

bool SettingsBridge::liveAudioMonitoringEnabled() const
{
    return m_liveAudioMonitoringEnabled;
}

void SettingsBridge::setLiveAudioMonitoringEnabled(bool value)
{
    if (m_liveAudioMonitoringEnabled == value)
        return;

    m_liveAudioMonitoringEnabled = value;
    m_settings.setValue("liveAudioMonitoringEnabled", value);
    m_settings.sync();
    emit liveAudioMonitoringEnabledChanged();
}

bool SettingsBridge::audioMeterEnabled() const
{
    return m_audioMeterEnabled;
}

void SettingsBridge::setAudioMeterEnabled(bool value)
{
    if (m_audioMeterEnabled == value)
        return;

    m_audioMeterEnabled = value;
    m_settings.setValue("audioMeterEnabled", value);
    m_settings.sync();
    emit audioMeterEnabledChanged();
}

QString SettingsBridge::audioInputDevice() const
{
    return m_audioInputDevice;
}

void SettingsBridge::setAudioInputDevice(const QString &value)
{
    const QString normalized = value.trimmed().compare(QStringLiteral("Auto"), Qt::CaseInsensitive) == 0
        ? QString()
        : value.trimmed();

    if (m_audioInputDevice == normalized)
        return;

    m_audioInputDevice = normalized;
    m_settings.setValue("audioInputDevice", normalized);
    m_settings.sync();
    emit audioInputDeviceChanged();
}

QString SettingsBridge::audioOutputDevice() const
{
    return m_audioOutputDevice;
}

void SettingsBridge::setAudioOutputDevice(const QString &value)
{
    const QString normalized = value.trimmed().compare(QStringLiteral("Auto"), Qt::CaseInsensitive) == 0
        ? QString()
        : value.trimmed();

    if (m_audioOutputDevice == normalized)
        return;

    m_audioOutputDevice = normalized;
    m_settings.setValue("audioOutputDevice", normalized);
    m_settings.sync();
    emit audioOutputDeviceChanged();
}

int SettingsBridge::inputVolume() const
{
    return m_inputVolume;
}

void SettingsBridge::setInputVolume(int value)
{
    const int clamped = qBound(0, value, 100);
    if (m_inputVolume == clamped)
        return;

    m_inputVolume = clamped;
    m_settings.setValue("inputVolume", clamped);
    m_settings.sync();
    emit inputVolumeChanged();
}

int SettingsBridge::headphoneVolume() const
{
    return m_headphoneVolume;
}

void SettingsBridge::setHeadphoneVolume(int value)
{
    const int clamped = qBound(0, value, 100);
    if (m_headphoneVolume == clamped)
        return;

    m_headphoneVolume = clamped;
    m_settings.setValue("headphoneVolume", clamped);
    m_settings.sync();
    emit headphoneVolumeChanged();
}

QString SettingsBridge::batteryCapacity() const
{
    return m_batteryCapacity;
}

void SettingsBridge::setBatteryCapacity(const QString &value)
{
    if (m_batteryCapacity == value)
        return;

    m_batteryCapacity = value;
    m_settings.setValue("batteryCapacity", value);
    emit batteryCapacityChanged();
}

int SettingsBridge::customBatteryWh() const
{
    return m_customBatteryWh;
}

void SettingsBridge::setCustomBatteryWh(int value)
{
    const int clamped = qBound(10, value, 500);
    if (m_customBatteryWh == clamped)
        return;

    m_customBatteryWh = clamped;
    m_settings.setValue("customBatteryWh", clamped);
    emit customBatteryWhChanged();
}

QString SettingsBridge::sleepMode() const
{
    return m_sleepMode;
}

void SettingsBridge::setSleepMode(const QString &value)
{
    if (m_sleepMode == value)
        return;

    m_sleepMode = value;
    m_settings.setValue("sleepMode", value);
    emit sleepModeChanged();
}

QStringList SettingsBridge::monitoringOrder() const
{
    return m_monitoringOrder;
}

void SettingsBridge::setMonitoringOrder(const QStringList &value)
{
    if (m_monitoringOrder == value)
        return;

    m_monitoringOrder = value;
    m_settings.setValue("monitoringOrder", value);
    emit monitoringOrderChanged();
}

QStringList SettingsBridge::recordOrder() const
{
    return m_recordOrder;
}

void SettingsBridge::setRecordOrder(const QStringList &value)
{
    if (m_recordOrder == value)
        return;

    m_recordOrder = value;
    m_settings.setValue("recordOrder", value);
    emit recordOrderChanged();
}

QStringList SettingsBridge::audioOrder() const
{
    return m_audioOrder;
}

void SettingsBridge::setAudioOrder(const QStringList &value)
{
    if (m_audioOrder == value)
        return;

    m_audioOrder = value;
    m_settings.setValue("audioOrder", value);
    emit audioOrderChanged();
}

QStringList SettingsBridge::powerOrder() const
{
    return m_powerOrder;
}

void SettingsBridge::setPowerOrder(const QStringList &value)
{
    if (m_powerOrder == value)
        return;

    m_powerOrder = value;
    m_settings.setValue("powerOrder", value);
    emit powerOrderChanged();
}

QStringList SettingsBridge::systemOrder() const
{
    return m_systemOrder;
}

void SettingsBridge::setSystemOrder(const QStringList &value)
{
    if (m_systemOrder == value)
        return;

    m_systemOrder = value;
    m_settings.setValue("systemOrder", value);
    emit systemOrderChanged();
}

QStringList SettingsBridge::wifiOrder() const
{
    return m_wifiOrder;
}

void SettingsBridge::setWifiOrder(const QStringList &value)
{
    if (m_wifiOrder == value)
        return;

    m_wifiOrder = value;
    m_settings.setValue("wifiOrder", value);
    emit wifiOrderChanged();
}

QStringList SettingsBridge::infoOrder() const
{
    return m_infoOrder;
}

void SettingsBridge::setInfoOrder(const QStringList &value)
{
    if (m_infoOrder == value)
        return;

    m_infoOrder = value;
    m_settings.setValue("infoOrder", value);
    emit infoOrderChanged();
}

QStringList SettingsBridge::sidebarOrder() const
{
    return m_sidebarOrder;
}

void SettingsBridge::setSidebarOrder(const QStringList &value)
{
    if (m_sidebarOrder == value)
        return;

    m_sidebarOrder = value;
    m_settings.setValue("sidebarOrder", value);
    emit sidebarOrderChanged();
}

QStringList SettingsBridge::favoritesOrder() const
{
    return m_favoritesOrder;
}

void SettingsBridge::setFavoritesOrder(const QStringList &value)
{
    if (m_favoritesOrder == value)
        return;

    m_favoritesOrder = value;
    m_settings.setValue("favoritesOrder", value);
    emit favoritesOrderChanged();
}

QStringList SettingsBridge::presetNames() const
{
    return m_presetNames;
}

QString SettingsBridge::presetStatusText() const
{
    return m_presetStatusText;
}

bool SettingsBridge::presetStatusError() const
{
    return m_presetStatusError;
}

bool SettingsBridge::saveCurrentAsPreset(const QString &name)
{
    const QString trimmedName = name.trimmed();
    if (trimmedName.isEmpty()) {
        setPresetStatus(QStringLiteral("Preset name cannot be empty."), true);
        return false;
    }

    QString errorMessage;
    if (!writePresetFile(presetFilePathForName(trimmedName),
                         trimmedName,
                         serializeCurrentSettings(),
                         &errorMessage)) {
        setPresetStatus(errorMessage, true);
        return false;
    }

    reloadPresetNames();
    clearPresetStatus();
    return true;
}

bool SettingsBridge::loadPreset(const QString &name)
{
    QString presetName;
    QJsonObject settingsObject;
    QString errorMessage;
    if (!readPresetFile(presetFilePathForName(name), &presetName, &settingsObject, &errorMessage)) {
        setPresetStatus(errorMessage, true);
        return false;
    }

    if (!applySettingsObject(settingsObject, &errorMessage)) {
        setPresetStatus(errorMessage, true);
        return false;
    }

    m_settings.sync();
    setPresetStatus(QStringLiteral("Loaded preset \"%1\".").arg(presetName), false);
    return true;
}

bool SettingsBridge::deletePreset(const QString &name)
{
    const QString filePath = presetFilePathForName(name);
    QFile file(filePath);
    if (!file.exists()) {
        setPresetStatus(QStringLiteral("Preset \"%1\" was not found.").arg(name), true);
        return false;
    }

    if (!file.remove()) {
        setPresetStatus(QStringLiteral("Preset \"%1\" could not be deleted.").arg(name), true);
        return false;
    }

    reloadPresetNames();
    clearPresetStatus();
    return true;
}

bool SettingsBridge::exportPresetToPath(const QString &name, const QString &mediaMountPath)
{
    const QString trimmedMountPath = mediaMountPath.trimmed();
    if (trimmedMountPath.isEmpty()) {
        setPresetStatus(QStringLiteral("No media path is available for preset export."), true);
        return false;
    }

    const QDir mediaDir(trimmedMountPath);
    if (!mediaDir.exists()) {
        setPresetStatus(QStringLiteral("The media path \"%1\" is not available.").arg(trimmedMountPath), true);
        return false;
    }

    const QString exportDirPath = mediaDir.filePath(QStringLiteral("Apertar Presets"));
    if (!QDir().mkpath(exportDirPath)) {
        setPresetStatus(QStringLiteral("Could not create the preset export folder on media."), true);
        return false;
    }

    QString presetName;
    QJsonObject settingsObject;
    QString errorMessage;
    if (!readPresetFile(presetFilePathForName(name), &presetName, &settingsObject, &errorMessage)) {
        setPresetStatus(errorMessage, true);
        return false;
    }

    const QString exportPath = QDir(exportDirPath).filePath(
        sanitizedPresetFileStem(presetName) + QStringLiteral(".apertar-preset.json"));
    if (!writePresetFile(exportPath, presetName, settingsObject, &errorMessage)) {
        setPresetStatus(errorMessage, true);
        return false;
    }

    setPresetStatus(QStringLiteral("Exported \"%1\" to media.").arg(presetName), false);
    return true;
}

bool SettingsBridge::importPresetsFromPath(const QString &mediaMountPath)
{
    const QString trimmedMountPath = mediaMountPath.trimmed();
    if (trimmedMountPath.isEmpty()) {
        setPresetStatus(QStringLiteral("No media path is available for preset import."), true);
        return false;
    }

    const QDir mediaDir(trimmedMountPath);
    if (!mediaDir.exists()) {
        setPresetStatus(QStringLiteral("The media path \"%1\" is not available.").arg(trimmedMountPath), true);
        return false;
    }

    QStringList candidateFiles;
    const QStringList filters = {QStringLiteral("*.apertar-preset.json")};
    for (const QFileInfo &info : mediaDir.entryInfoList(filters, QDir::Files | QDir::Readable, QDir::Name))
        candidateFiles.push_back(info.absoluteFilePath());

    const QDir exportDir(mediaDir.filePath(QStringLiteral("Apertar Presets")));
    if (exportDir.exists()) {
        for (const QFileInfo &info : exportDir.entryInfoList(filters, QDir::Files | QDir::Readable, QDir::Name))
            candidateFiles.push_back(info.absoluteFilePath());
    }

    candidateFiles.removeDuplicates();
    if (candidateFiles.isEmpty()) {
        setPresetStatus(QStringLiteral("No preset files were found on the media drive."), true);
        return false;
    }

    int importedCount = 0;
    int skippedDuplicateCount = 0;
    QStringList importedNames;
    QStringList duplicateNames;
    const auto batchNameExists = [this, &importedNames](const QString &name) {
        for (const QString &existing : m_presetNames) {
            if (existing.compare(name, Qt::CaseInsensitive) == 0)
                return true;
        }
        for (const QString &imported : importedNames) {
            if (imported.compare(name, Qt::CaseInsensitive) == 0)
                return true;
        }
        return false;
    };
    for (const QString &filePath : candidateFiles) {
        QString presetName;
        QJsonObject settingsObject;
        QString errorMessage;
        if (!readPresetFile(filePath, &presetName, &settingsObject, &errorMessage))
            continue;

        QString finalName = presetName.trimmed();
        if (finalName.isEmpty())
            finalName = QStringLiteral("Imported Preset");
        if (batchNameExists(finalName)) {
            duplicateNames.push_back(finalName);
            ++skippedDuplicateCount;
            continue;
        }
        if (!writePresetFile(presetFilePathForName(finalName), finalName, settingsObject, &errorMessage))
            continue;

        importedNames.push_back(finalName);
        ++importedCount;
    }

    reloadPresetNames();

    if (importedCount == 0) {
        if (skippedDuplicateCount > 0) {
            if (skippedDuplicateCount == 1) {
                setPresetStatus(QStringLiteral("Preset \"%1\" is already in the library.")
                                    .arg(duplicateNames.constFirst()),
                                false);
            } else {
                setPresetStatus(QStringLiteral("All %1 presets already exist in the library.")
                                    .arg(skippedDuplicateCount),
                                false);
            }
            return true;
        }

        setPresetStatus(QStringLiteral("No valid preset files could be imported."), true);
        return false;
    }

    if (skippedDuplicateCount > 0) {
        setPresetStatus(QStringLiteral("Imported %1 preset%2. %3 already exist%4 in the library.")
                            .arg(importedCount)
                            .arg(importedCount == 1 ? QString() : QStringLiteral("s"))
                            .arg(skippedDuplicateCount)
                            .arg(skippedDuplicateCount == 1 ? QStringLiteral("s") : QString()),
                        false);
    } else {
        setPresetStatus(
            importedCount == 1
                ? QStringLiteral("Imported preset \"%1\".").arg(importedNames.constFirst())
                : QStringLiteral("Imported %1 presets from media.").arg(importedCount),
            false);
    }
    return true;
}

void SettingsBridge::clearPresetStatus()
{
    setPresetStatus(QString(), false);
}

QString SettingsBridge::presetsDirectoryPath() const
{
    const QString appDataPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    const QString appDataPresetsPath = appDataPath.isEmpty()
        ? QString()
        : QDir(appDataPath).filePath(QStringLiteral("presets"));
    const QString legacyPresetsPath = QDir(QDir::homePath() + QStringLiteral("/.config/CinePi/UI"))
        .filePath(QStringLiteral("presets"));

    const QDir appDataDir(appDataPresetsPath);
    if (!appDataPresetsPath.isEmpty() && appDataDir.exists())
        return appDataPresetsPath;

    const QDir legacyDir(legacyPresetsPath);
    if (legacyDir.exists())
        return legacyPresetsPath;

    if (!appDataPresetsPath.isEmpty())
        return appDataPresetsPath;

    return legacyPresetsPath;
}

QStringList SettingsBridge::currentPresetDirectorySignature() const
{
    const QDir dir(presetsDirectoryPath());
    QStringList signature;
    if (!dir.exists())
        return signature;

    const QFileInfoList files = dir.entryInfoList(
        {QStringLiteral("*.apertar-preset.json")},
        QDir::Files | QDir::Readable,
        QDir::Name | QDir::IgnoreCase);

    signature.reserve(files.size());
    for (const QFileInfo &info : files) {
        signature.push_back(
            info.fileName()
            + QLatin1Char('|')
            + QString::number(info.lastModified().toMSecsSinceEpoch())
            + QLatin1Char('|')
            + QString::number(info.size()));
    }
    return signature;
}

QString SettingsBridge::sanitizedPresetFileStem(const QString &name) const
{
    QString stem = name.simplified();
    if (stem.isEmpty())
        stem = QStringLiteral("Preset");

    static const QString invalidCharacters = QStringLiteral("\\/:*?\"<>|");
    for (const QChar invalid : invalidCharacters)
        stem.replace(invalid, QLatin1Char('_'));

    stem.replace(QLatin1Char('\n'), QLatin1Char('_'));
    stem.replace(QLatin1Char('\r'), QLatin1Char('_'));
    stem.replace(QStringLiteral("  "), QStringLiteral(" "));
    return stem;
}

QString SettingsBridge::presetFilePathForName(const QString &name) const
{
    return QDir(presetsDirectoryPath()).filePath(
        sanitizedPresetFileStem(name) + QStringLiteral(".apertar-preset.json"));
}

QString SettingsBridge::uniquePresetName(const QString &baseName) const
{
    QString candidate = baseName.trimmed();
    if (candidate.isEmpty())
        candidate = QStringLiteral("Imported Preset");

    const auto nameExists = [this](const QString &name) {
        for (const QString &existing : m_presetNames) {
            if (existing.compare(name, Qt::CaseInsensitive) == 0)
                return true;
        }
        return false;
    };

    if (!nameExists(candidate))
        return candidate;

    const QString seed = candidate;
    int suffix = 2;
    while (nameExists(QStringLiteral("%1 (%2)").arg(seed).arg(suffix)))
        ++suffix;
    return QStringLiteral("%1 (%2)").arg(seed).arg(suffix);
}

QJsonObject SettingsBridge::serializeCurrentSettings() const
{
    QJsonObject settingsObject;
    settingsObject.insert(QStringLiteral("zebraEnabled"), m_zebraEnabled);
    settingsObject.insert(QStringLiteral("zebraThreshold"), m_zebraThreshold);
    settingsObject.insert(QStringLiteral("focusPeakingEnabled"), m_focusPeakingEnabled);
    settingsObject.insert(QStringLiteral("focusPeakingThreshold"), m_focusPeakingThreshold);
    settingsObject.insert(QStringLiteral("focusPeakingColor"), m_focusPeakingColor);
    settingsObject.insert(QStringLiteral("grayscaleEnabled"), m_grayscaleEnabled);
    settingsObject.insert(QStringLiteral("smpteEnabled"), m_smpteEnabled);
    settingsObject.insert(QStringLiteral("anamorphicDesqueezeEnabled"), m_anamorphicDesqueezeEnabled);
    settingsObject.insert(QStringLiteral("anamorphicRatio"), m_anamorphicRatio);
    settingsObject.insert(QStringLiteral("falseColorEnabled"), m_falseColorEnabled);
    settingsObject.insert(QStringLiteral("falseColorMode"), m_falseColorMode);
    settingsObject.insert(QStringLiteral("guidesEnabled"), m_guidesEnabled);
    settingsObject.insert(QStringLiteral("guidesType"), m_guidesType);
    settingsObject.insert(QStringLiteral("guidesThickness"), m_guidesThickness);
    settingsObject.insert(QStringLiteral("centerMarkerEnabled"), m_centerMarkerEnabled);
    settingsObject.insert(QStringLiteral("centerMarkerType"), m_centerMarkerType);
    settingsObject.insert(QStringLiteral("uiOrientation"), m_uiOrientation);
    settingsObject.insert(QStringLiteral("cameraControlsOpacity"), m_cameraControlsOpacity);
    settingsObject.insert(QStringLiteral("cameraControlsMode"), m_cameraControlsMode);
    settingsObject.insert(QStringLiteral("externalMonitorEnabled"), m_externalMonitorEnabled);
    settingsObject.insert(QStringLiteral("externalMonitorMode"), m_externalMonitorMode);
    settingsObject.insert(QStringLiteral("externalMonitorInfoOverlay"), m_externalMonitorInfoOverlay);
    settingsObject.insert(QStringLiteral("externalMonitorOrientation"), m_externalMonitorOrientation);
    settingsObject.insert(QStringLiteral("dateTimeOverlayEnabled"), m_dateTimeOverlayEnabled);
    settingsObject.insert(QStringLiteral("timecodeMode"), m_timecodeMode);
    settingsObject.insert(QStringLiteral("photoModeEnabled"), m_photoModeEnabled);
    settingsObject.insert(QStringLiteral("photoTimer"), m_photoTimer);
    settingsObject.insert(QStringLiteral("photoBurst"), m_photoBurst);
    settingsObject.insert(QStringLiteral("photoFormat"), m_photoFormat);
    settingsObject.insert(QStringLiteral("recordAudioEnabled"), m_recordAudioEnabled);
    settingsObject.insert(QStringLiteral("liveAudioMonitoringEnabled"), m_liveAudioMonitoringEnabled);
    settingsObject.insert(QStringLiteral("audioMeterEnabled"), m_audioMeterEnabled);
    settingsObject.insert(QStringLiteral("audioInputDevice"), m_audioInputDevice);
    settingsObject.insert(QStringLiteral("audioOutputDevice"), m_audioOutputDevice);
    settingsObject.insert(QStringLiteral("inputVolume"), m_inputVolume);
    settingsObject.insert(QStringLiteral("headphoneVolume"), m_headphoneVolume);
    settingsObject.insert(QStringLiteral("batteryCapacity"), m_batteryCapacity);
    settingsObject.insert(QStringLiteral("customBatteryWh"), m_customBatteryWh);
    settingsObject.insert(QStringLiteral("sleepMode"), m_sleepMode);
    if (m_controlBridge) {
        settingsObject.insert(QStringLiteral("cameraFps"), m_controlBridge->fps());
        settingsObject.insert(QStringLiteral("cameraIso"), m_controlBridge->iso());
        settingsObject.insert(QStringLiteral("cameraShutterMode"),
                              m_photoModeEnabled ? QStringLiteral("speed") : QStringLiteral("angle"));
        settingsObject.insert(QStringLiteral("cameraShutterAngle"), m_controlBridge->shutterAngle());
        settingsObject.insert(QStringLiteral("cameraShutterSpeed"), m_controlBridge->shutterSpeed());
        settingsObject.insert(QStringLiteral("cameraWhiteBalance"), m_controlBridge->whiteBalance());
    }
    settingsObject.insert(QStringLiteral("monitoringOrder"), QJsonArray::fromStringList(m_monitoringOrder));
    settingsObject.insert(QStringLiteral("recordOrder"), QJsonArray::fromStringList(m_recordOrder));
    settingsObject.insert(QStringLiteral("audioOrder"), QJsonArray::fromStringList(m_audioOrder));
    settingsObject.insert(QStringLiteral("powerOrder"), QJsonArray::fromStringList(m_powerOrder));
    settingsObject.insert(QStringLiteral("systemOrder"), QJsonArray::fromStringList(m_systemOrder));
    settingsObject.insert(QStringLiteral("wifiOrder"), QJsonArray::fromStringList(m_wifiOrder));
    settingsObject.insert(QStringLiteral("infoOrder"), QJsonArray::fromStringList(m_infoOrder));
    settingsObject.insert(QStringLiteral("sidebarOrder"), QJsonArray::fromStringList(m_sidebarOrder));
    settingsObject.insert(QStringLiteral("favoritesOrder"), QJsonArray::fromStringList(m_favoritesOrder));
    return settingsObject;
}

bool SettingsBridge::applySettingsObject(const QJsonObject &settingsObject, QString *errorMessage)
{
    if (settingsObject.isEmpty()) {
        if (errorMessage)
            *errorMessage = QStringLiteral("The preset file did not contain any settings.");
        return false;
    }

    setZebraEnabled(boolValue(settingsObject, "zebraEnabled", m_zebraEnabled));
    setZebraThreshold(static_cast<float>(doubleValue(settingsObject, "zebraThreshold", m_zebraThreshold)));
    setFocusPeakingEnabled(boolValue(settingsObject, "focusPeakingEnabled", m_focusPeakingEnabled));
    setFocusPeakingThreshold(static_cast<float>(doubleValue(settingsObject, "focusPeakingThreshold", m_focusPeakingThreshold)));
    setFocusPeakingColor(stringValue(settingsObject, "focusPeakingColor", m_focusPeakingColor));
    setGrayscaleEnabled(boolValue(settingsObject, "grayscaleEnabled", m_grayscaleEnabled));
    setSmpteEnabled(boolValue(settingsObject, "smpteEnabled", m_smpteEnabled));
    setAnamorphicDesqueezeEnabled(boolValue(settingsObject, "anamorphicDesqueezeEnabled", m_anamorphicDesqueezeEnabled));
    setAnamorphicRatio(stringValue(settingsObject, "anamorphicRatio", m_anamorphicRatio));
    setFalseColorEnabled(boolValue(settingsObject, "falseColorEnabled", m_falseColorEnabled));
    setFalseColorMode(intValue(settingsObject, "falseColorMode", m_falseColorMode));
    setGuidesEnabled(boolValue(settingsObject, "guidesEnabled", m_guidesEnabled));
    setGuidesType(stringValue(settingsObject, "guidesType", m_guidesType));
    setGuidesThickness(intValue(settingsObject, "guidesThickness", m_guidesThickness));
    setCenterMarkerEnabled(boolValue(settingsObject, "centerMarkerEnabled", m_centerMarkerEnabled));
    setCenterMarkerType(stringValue(settingsObject, "centerMarkerType", m_centerMarkerType));
    setUiOrientation(stringValue(settingsObject, "uiOrientation", m_uiOrientation));
    setCameraControlsOpacity(doubleValue(settingsObject, "cameraControlsOpacity", m_cameraControlsOpacity));
    setCameraControlsMode(stringValue(settingsObject, "cameraControlsMode", m_cameraControlsMode));
    setExternalMonitorEnabled(boolValue(settingsObject, "externalMonitorEnabled", m_externalMonitorEnabled));
    setExternalMonitorMode(stringValue(settingsObject, "externalMonitorMode", m_externalMonitorMode));
    setExternalMonitorInfoOverlay(stringValue(settingsObject, "externalMonitorInfoOverlay", m_externalMonitorInfoOverlay));
    setExternalMonitorOrientation(stringValue(settingsObject, "externalMonitorOrientation", m_externalMonitorOrientation));
    setDateTimeOverlayEnabled(boolValue(settingsObject, "dateTimeOverlayEnabled", m_dateTimeOverlayEnabled));
    setTimecodeMode(stringValue(settingsObject, "timecodeMode", m_timecodeMode));
    setPhotoModeEnabled(boolValue(settingsObject, "photoModeEnabled", m_photoModeEnabled));
    setPhotoTimer(stringValue(settingsObject, "photoTimer", m_photoTimer));
    setPhotoBurst(stringValue(settingsObject, "photoBurst", m_photoBurst));
    setPhotoFormat(stringValue(settingsObject, "photoFormat", m_photoFormat));
    setRecordAudioEnabled(boolValue(settingsObject, "recordAudioEnabled", m_recordAudioEnabled));
    setLiveAudioMonitoringEnabled(boolValue(settingsObject, "liveAudioMonitoringEnabled", m_liveAudioMonitoringEnabled));
    setAudioMeterEnabled(boolValue(settingsObject, "audioMeterEnabled", m_audioMeterEnabled));
    setAudioInputDevice(stringValue(settingsObject, "audioInputDevice", m_audioInputDevice));
    setAudioOutputDevice(stringValue(settingsObject, "audioOutputDevice", m_audioOutputDevice));
    setInputVolume(intValue(settingsObject, "inputVolume", m_inputVolume));
    setHeadphoneVolume(intValue(settingsObject, "headphoneVolume", m_headphoneVolume));
    setBatteryCapacity(stringValue(settingsObject, "batteryCapacity", m_batteryCapacity));
    setCustomBatteryWh(intValue(settingsObject, "customBatteryWh", m_customBatteryWh));
    setSleepMode(stringValue(settingsObject, "sleepMode", m_sleepMode));
    setMonitoringOrder(stringListValue(settingsObject, "monitoringOrder", m_monitoringOrder));
    setRecordOrder(stringListValue(settingsObject, "recordOrder", m_recordOrder));
    setAudioOrder(stringListValue(settingsObject, "audioOrder", m_audioOrder));
    setPowerOrder(stringListValue(settingsObject, "powerOrder", m_powerOrder));
    setSystemOrder(stringListValue(settingsObject, "systemOrder", m_systemOrder));
    setWifiOrder(stringListValue(settingsObject, "wifiOrder", m_wifiOrder));
    setInfoOrder(stringListValue(settingsObject, "infoOrder", m_infoOrder));
    setSidebarOrder(stringListValue(settingsObject, "sidebarOrder", m_sidebarOrder));
    setFavoritesOrder(stringListValue(settingsObject, "favoritesOrder", m_favoritesOrder));

    if (m_controlBridge) {
        const QString presetFps = stringValue(settingsObject, "cameraFps", m_controlBridge->fps());
        const QString presetIso = stringValue(settingsObject, "cameraIso", m_controlBridge->iso());
        const QString presetWhiteBalance = stringValue(
            settingsObject,
            "cameraWhiteBalance",
            m_controlBridge->whiteBalance());
        const QString presetShutterMode = stringValue(
            settingsObject,
            "cameraShutterMode",
            m_photoModeEnabled ? QStringLiteral("speed") : QStringLiteral("angle"));
        const QString presetShutterAngle = stringValue(
            settingsObject,
            "cameraShutterAngle",
            m_controlBridge->shutterAngle());
        const QString presetShutterSpeed = stringValue(
            settingsObject,
            "cameraShutterSpeed",
            m_controlBridge->shutterSpeed());

        if (!presetFps.isEmpty() && !m_controlBridge->applyFps(presetFps)) {
            if (errorMessage)
                *errorMessage = m_controlBridge->lastError().isEmpty()
                    ? QStringLiteral("The preset FPS could not be applied.")
                    : m_controlBridge->lastError();
            return false;
        }

        if (!presetIso.isEmpty() && !m_controlBridge->applyIso(presetIso)) {
            if (errorMessage)
                *errorMessage = m_controlBridge->lastError().isEmpty()
                    ? QStringLiteral("The preset ISO could not be applied.")
                    : m_controlBridge->lastError();
            return false;
        }

        const bool useShutterSpeed = presetShutterMode == QStringLiteral("speed");
        const QString shutterValue = useShutterSpeed ? presetShutterSpeed : presetShutterAngle;
        if (!shutterValue.isEmpty()) {
            const bool shutterApplied = useShutterSpeed
                ? m_controlBridge->applyShutterSpeed(shutterValue)
                : m_controlBridge->applyShutterAngle(shutterValue);
            if (!shutterApplied) {
                if (errorMessage)
                    *errorMessage = m_controlBridge->lastError().isEmpty()
                        ? QStringLiteral("The preset shutter value could not be applied.")
                        : m_controlBridge->lastError();
                return false;
            }
        }

        if (!presetWhiteBalance.isEmpty() && !m_controlBridge->applyWhiteBalance(presetWhiteBalance)) {
            if (errorMessage)
                *errorMessage = m_controlBridge->lastError().isEmpty()
                    ? QStringLiteral("The preset white balance could not be applied.")
                    : m_controlBridge->lastError();
            return false;
        }
    }

    return true;
}

bool SettingsBridge::writePresetFile(const QString &filePath,
                                     const QString &presetName,
                                     const QJsonObject &settingsObject,
                                     QString *errorMessage) const
{
    const QFileInfo fileInfo(filePath);
    if (!QDir().mkpath(fileInfo.dir().absolutePath())) {
        if (errorMessage)
            *errorMessage = QStringLiteral("Could not create the preset folder.");
        return false;
    }

    QJsonObject rootObject;
    rootObject.insert(QStringLiteral("type"), QStringLiteral("apertar-preset"));
    rootObject.insert(QStringLiteral("version"), 1);
    rootObject.insert(QStringLiteral("name"), presetName.trimmed());
    rootObject.insert(QStringLiteral("createdAt"), QDateTime::currentDateTimeUtc().toString(Qt::ISODate));
    rootObject.insert(QStringLiteral("settings"), settingsObject);

    QSaveFile file(filePath);
    if (!file.open(QIODevice::WriteOnly)) {
        if (errorMessage)
            *errorMessage = QStringLiteral("Could not open the preset file for writing.");
        return false;
    }

    const QByteArray payload = QJsonDocument(rootObject).toJson(QJsonDocument::Indented);
    if (file.write(payload) != payload.size()) {
        if (errorMessage)
            *errorMessage = QStringLiteral("Could not write the preset file.");
        return false;
    }

    if (!file.commit()) {
        if (errorMessage)
            *errorMessage = QStringLiteral("Could not finalize the preset file.");
        return false;
    }

    return true;
}

bool SettingsBridge::readPresetFile(const QString &filePath,
                                    QString *presetName,
                                    QJsonObject *settingsObject,
                                    QString *errorMessage) const
{
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        if (errorMessage)
            *errorMessage = QStringLiteral("Could not open the preset file.");
        return false;
    }

    QJsonParseError parseError;
    const QJsonDocument document = QJsonDocument::fromJson(file.readAll(), &parseError);
    if (document.isNull() || !document.isObject()) {
        if (errorMessage)
            *errorMessage = QStringLiteral("Preset file is invalid JSON (%1).").arg(parseError.errorString());
        return false;
    }

    const QJsonObject rootObject = document.object();
    const QJsonObject payload = rootObject.value(QStringLiteral("settings")).isObject()
        ? rootObject.value(QStringLiteral("settings")).toObject()
        : rootObject;

    const QString resolvedName = stringValue(rootObject, "name", QFileInfo(filePath).completeBaseName());
    if (presetName)
        *presetName = resolvedName.trimmed().isEmpty() ? QStringLiteral("Preset") : resolvedName.trimmed();
    if (settingsObject)
        *settingsObject = payload;
    return true;
}

void SettingsBridge::reloadPresetNames()
{
    const QDir dir(presetsDirectoryPath());
    QStringList names;
    QStringList signature;
    if (dir.exists()) {
        const QFileInfoList files = dir.entryInfoList(
            {QStringLiteral("*.apertar-preset.json")},
            QDir::Files | QDir::Readable,
            QDir::Name | QDir::IgnoreCase);

        signature.reserve(files.size());
        for (const QFileInfo &info : files) {
            signature.push_back(
                info.fileName()
                + QLatin1Char('|')
                + QString::number(info.lastModified().toMSecsSinceEpoch())
                + QLatin1Char('|')
                + QString::number(info.size()));
            QString presetName;
            QJsonObject settingsObject;
            QString errorMessage;
            if (readPresetFile(info.absoluteFilePath(), &presetName, &settingsObject, &errorMessage))
                names.push_back(presetName);
        }
    }

    std::sort(names.begin(), names.end(), [](const QString &lhs, const QString &rhs) {
        return lhs.localeAwareCompare(rhs) < 0;
    });

    if (m_presetNames == names && m_presetDirectorySignature == signature)
        return;

    m_presetNames = names;
    m_presetDirectorySignature = signature;
    emit presetNamesChanged();
}

void SettingsBridge::setPresetStatus(const QString &text, bool error)
{
    if (m_presetStatusText == text && m_presetStatusError == error)
        return;

    m_presetStatusText = text;
    m_presetStatusError = error;
    emit presetStatusChanged();
}
