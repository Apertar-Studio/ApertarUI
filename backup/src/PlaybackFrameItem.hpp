#pragma once

#include <QHash>
#include <QImage>
#include <QMutex>
#include <QQuickItem>
#include <QSet>
#include <QStringList>
#include <QThreadPool>

class QSGNode;

class PlaybackFrameItem : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(QString framePath READ framePath WRITE setFramePath NOTIFY framePathChanged)
    Q_PROPERTY(QStringList preloadFramePaths READ preloadFramePaths WRITE setPreloadFramePaths NOTIFY preloadFramePathsChanged)
    Q_PROPERTY(bool playing READ playing WRITE setPlaying NOTIFY playingChanged)
    Q_PROPERTY(int radius READ radius WRITE setRadius NOTIFY radiusChanged)

public:
    explicit PlaybackFrameItem(QQuickItem *parent = nullptr);
    ~PlaybackFrameItem() override;

    QString framePath() const { return m_framePath; }
    void setFramePath(const QString &framePath);

    QStringList preloadFramePaths() const { return m_preloadFramePaths; }
    void setPreloadFramePaths(const QStringList &paths);

    bool playing() const { return m_playing; }
    void setPlaying(bool playing);

    int radius() const { return m_radius; }
    void setRadius(int radius);

signals:
    void framePathChanged();
    void preloadFramePathsChanged();
    void playingChanged();
    void radiusChanged();

protected:
    QSGNode *updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *) override;
    void geometryChange(const QRectF &newGeometry, const QRectF &oldGeometry) override;

private:
    QString cacheKeyFor(const QString &path, const QSize &size, bool previewOnly) const;
    QSize displayTargetSize() const;
    QSize prefetchTargetSize() const;
    void insertCache(const QString &cacheKey, const QImage &image);
    void applyLoadedImage(const QString &cacheKey, const QImage &image, bool displayRequest);
    void scheduleDisplayLoad();
    void schedulePrefetch();
    void enqueueLoad(const QString &path,
                     const QSize &size,
                     bool previewOnly,
                     bool displayRequest,
                     int priority);

    QString m_framePath;
    QStringList m_preloadFramePaths;
    bool m_playing = false;
    int m_radius = 24;

    QThreadPool m_loaderThreadPool;
    mutable QMutex m_stateMutex;
    QHash<QString, QImage> m_imageCache;
    QSet<QString> m_inFlightKeys;
    QString m_requestedDisplayKey;
    QString m_pendingDisplayKey;
    QImage m_pendingDisplayImage;
    bool m_shuttingDown = false;
    static constexpr int kCacheLimit = 64;
};
