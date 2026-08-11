#include "PlaybackFrameItem.hpp"

#include <QCoreApplication>
#include <QMetaObject>
#include <QMutexLocker>
#include <QPointer>
#include <QQuickWindow>
#include <QRunnable>
#include <QSGSimpleTextureNode>
#include <QSGTexture>

#include <algorithm>

#include "cdngimageprovider.h"

namespace {
QRectF aspectFitRect(const QSize &sourceSize, const QRectF &targetRect)
{
    if (!sourceSize.isValid() || targetRect.width() <= 0.0 || targetRect.height() <= 0.0)
        return targetRect;

    const qreal sourceAspect = static_cast<qreal>(sourceSize.width()) / static_cast<qreal>(sourceSize.height());
    const qreal targetAspect = targetRect.width() / targetRect.height();

    if (sourceAspect > targetAspect) {
        const qreal height = targetRect.width() / sourceAspect;
        const qreal y = targetRect.y() + (targetRect.height() - height) * 0.5;
        return QRectF(targetRect.x(), y, targetRect.width(), height);
    }

    const qreal width = targetRect.height() * sourceAspect;
    const qreal x = targetRect.x() + (targetRect.width() - width) * 0.5;
    return QRectF(x, targetRect.y(), width, targetRect.height());
}
}

PlaybackFrameItem::PlaybackFrameItem(QQuickItem *parent)
    : QQuickItem(parent)
{
    setFlag(ItemHasContents, true);
    m_loaderThreadPool.setMaxThreadCount(2);
    m_loaderThreadPool.setExpiryTimeout(-1);
}

PlaybackFrameItem::~PlaybackFrameItem()
{
    {
        QMutexLocker locker(&m_stateMutex);
        m_shuttingDown = true;
        m_requestedDisplayKey.clear();
        m_pendingDisplayKey.clear();
        m_pendingDisplayImage = QImage();
        m_imageCache.clear();
        m_inFlightKeys.clear();
    }

    m_loaderThreadPool.waitForDone();
}

void PlaybackFrameItem::setFramePath(const QString &framePath)
{
    if (m_framePath == framePath)
        return;

    m_framePath = framePath;
    emit framePathChanged();
    scheduleDisplayLoad();
    schedulePrefetch();
}

void PlaybackFrameItem::setPreloadFramePaths(const QStringList &paths)
{
    if (m_preloadFramePaths == paths)
        return;

    m_preloadFramePaths = paths;
    emit preloadFramePathsChanged();
    schedulePrefetch();
}

void PlaybackFrameItem::setPlaying(bool playing)
{
    if (m_playing == playing)
        return;

    m_playing = playing;
    emit playingChanged();
    scheduleDisplayLoad();
    schedulePrefetch();
}

void PlaybackFrameItem::setRadius(int radius)
{
    radius = qMax(0, radius);
    if (m_radius == radius)
        return;

    m_radius = radius;
    emit radiusChanged();
    scheduleDisplayLoad();
    schedulePrefetch();
}

QSGNode *PlaybackFrameItem::updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *)
{
    auto *node = static_cast<QSGSimpleTextureNode *>(oldNode);
    if (!node) {
        node = new QSGSimpleTextureNode;
        node->setOwnsTexture(true);
        node->setFiltering(QSGTexture::Linear);
    }

    QImage pendingImage;
    {
        QMutexLocker locker(&m_stateMutex);
        if (m_shuttingDown) {
            delete node;
            return nullptr;
        }
        if (!m_pendingDisplayImage.isNull()) {
            pendingImage = m_pendingDisplayImage;
            m_pendingDisplayKey.clear();
            m_pendingDisplayImage = QImage();
        }
    }

    if (!pendingImage.isNull() && window()) {
        QSGTexture *newTexture = window()->createTextureFromImage(pendingImage);
        if (newTexture) {
            newTexture->setFiltering(QSGTexture::Linear);
            QSGTexture *oldTexture = node->texture();
            node->setOwnsTexture(false);
            node->setTexture(newTexture);
            node->setOwnsTexture(true);
            delete oldTexture;
        }
    }

    if (!node->texture()) {
        delete node;
        return nullptr;
    }

    node->setRect(aspectFitRect(node->texture()->textureSize(), boundingRect()));
    return node;
}

void PlaybackFrameItem::geometryChange(const QRectF &newGeometry, const QRectF &oldGeometry)
{
    QQuickItem::geometryChange(newGeometry, oldGeometry);
    if (newGeometry.size() != oldGeometry.size()) {
        scheduleDisplayLoad();
        schedulePrefetch();
    }
}

QString PlaybackFrameItem::cacheKeyFor(const QString &path, const QSize &size, bool previewOnly) const
{
    return QStringLiteral("%1|%2x%3|r%4|%5")
        .arg(path)
        .arg(size.width())
        .arg(size.height())
        .arg(m_radius)
        .arg(previewOnly ? QLatin1String("fast") : QLatin1String("full"));
}

QSize PlaybackFrameItem::displayTargetSize() const
{
    const qreal scale = m_playing ? 0.75 : 1.0;
    return QSize(qMax(2, qRound(width() * scale)),
                 qMax(2, qRound(height() * scale)));
}

QSize PlaybackFrameItem::prefetchTargetSize() const
{
    return QSize(qMax(2, qRound(width() * 0.75)),
                 qMax(2, qRound(height() * 0.75)));
}

void PlaybackFrameItem::insertCache(const QString &cacheKey, const QImage &image)
{
    if (image.isNull())
        return;

    QMutexLocker locker(&m_stateMutex);
    if (m_shuttingDown)
        return;
    if (m_imageCache.size() >= kCacheLimit)
        m_imageCache.clear();
    m_imageCache.insert(cacheKey, image);
}

void PlaybackFrameItem::applyLoadedImage(const QString &cacheKey, const QImage &image, bool displayRequest)
{
    bool shouldUpdate = false;
    bool shouldReloadLatestDisplay = false;

    {
        QMutexLocker locker(&m_stateMutex);
        if (m_shuttingDown)
            return;

        m_inFlightKeys.remove(cacheKey);
        if (!image.isNull()) {
            if (m_imageCache.size() >= kCacheLimit)
                m_imageCache.clear();
            m_imageCache.insert(cacheKey, image);
        }

        if (displayRequest && m_requestedDisplayKey == cacheKey && !image.isNull()) {
            m_pendingDisplayKey = cacheKey;
            m_pendingDisplayImage = image;
            shouldUpdate = true;
        } else if (displayRequest
                   && !m_requestedDisplayKey.isEmpty()
                   && m_requestedDisplayKey != cacheKey
                   && !m_inFlightKeys.contains(m_requestedDisplayKey)
                   && !m_imageCache.contains(m_requestedDisplayKey)) {
            shouldReloadLatestDisplay = true;
        }
    }

    if (shouldUpdate)
        update();
    else if (shouldReloadLatestDisplay)
        scheduleDisplayLoad();
}

void PlaybackFrameItem::scheduleDisplayLoad()
{
    if (m_framePath.isEmpty())
        return;

    const QSize size = displayTargetSize();
    if (!size.isValid())
        return;

    const bool previewOnly = m_playing;
    const QString cacheKey = cacheKeyFor(m_framePath, size, previewOnly);
    {
        QMutexLocker locker(&m_stateMutex);
        if (m_shuttingDown)
            return;
        m_requestedDisplayKey = cacheKey;
        const auto cached = m_imageCache.constFind(cacheKey);
        if (cached != m_imageCache.constEnd()) {
            m_pendingDisplayKey = cacheKey;
            m_pendingDisplayImage = cached.value();
            update();
            return;
        }
    }

    enqueueLoad(m_framePath, size, previewOnly, true, 1);
}

void PlaybackFrameItem::schedulePrefetch()
{
    const QSize size = prefetchTargetSize();
    if (!size.isValid())
        return;

    for (const QString &path : std::as_const(m_preloadFramePaths)) {
        if (path.isEmpty())
            continue;
        enqueueLoad(path, size, true, false, 0);
    }
}

void PlaybackFrameItem::enqueueLoad(const QString &path,
                                    const QSize &size,
                                    bool previewOnly,
                                    bool displayRequest,
                                    int priority)
{
    if (path.isEmpty() || !size.isValid())
        return;

    const QString cacheKey = cacheKeyFor(path, size, previewOnly);
    {
        QMutexLocker locker(&m_stateMutex);
        if (m_shuttingDown)
            return;
        if (m_imageCache.contains(cacheKey)) {
            if (displayRequest && m_requestedDisplayKey == cacheKey) {
                m_pendingDisplayKey = cacheKey;
                m_pendingDisplayImage = m_imageCache.value(cacheKey);
                update();
            }
            return;
        }

        if (m_inFlightKeys.contains(cacheKey))
            return;

        m_inFlightKeys.insert(cacheKey);
    }

    const int radius = m_radius;
    QPointer<PlaybackFrameItem> that(this);
    QObject *dispatchTarget = QCoreApplication::instance();
    m_loaderThreadPool.start(QRunnable::create([that, dispatchTarget, path, size, previewOnly, cacheKey, displayRequest, radius]() {
        const QImage image = CdngImageProvider::renderResolvedImage(path, size, previewOnly, radius);
        if (!dispatchTarget)
            return;

        QMetaObject::invokeMethod(dispatchTarget, [that, cacheKey, image, displayRequest]() {
            if (!that)
                return;
            that->applyLoadedImage(cacheKey, image, displayRequest);
        }, Qt::QueuedConnection);
    }), priority);
}
