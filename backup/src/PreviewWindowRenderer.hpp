#pragma once

#include <QObject>
#include <QPointer>
#include <QRectF>
#include <QElapsedTimer>
#include <QSize>
#include <array>
#include <optional>
#include <unordered_map>
#include <cstdint>

#include <EGL/egl.h>
#include <EGL/eglext.h>
#include <GLES2/gl2.h>
#include <GLES2/gl2ext.h>

#include "PreviewFrameInfo.hpp"

class QQuickWindow;
class CameraPreviewItem;

class PreviewWindowRenderer : public QObject
{
    Q_OBJECT

public:
    explicit PreviewWindowRenderer(QObject *parent = nullptr);
    ~PreviewWindowRenderer() override;

    void setPreviewItem(CameraPreviewItem *item);
    void setDirectWindowRendering(bool enabled) { m_directWindowRendering = enabled; }

private slots:
    void handleWindowChanged(QQuickWindow *window);
    void syncState();
    void render();

private:
    struct ImportedBuffer
    {
        GLuint texture = 0;
        EGLImageKHR image = EGL_NO_IMAGE_KHR;
        int dupFd = -1;
        std::array<int, 3> dupFds = { -1, -1, -1 };
        int sourceProcId = -1;
        int sourceFd = -1;
        uint64_t sourceBufferKey = 0;
        int sourceRawFd = -1;
        unsigned int width = 0;
        unsigned int height = 0;
        unsigned int stride = 0;
        unsigned int captureWidth = 0;
        unsigned int captureHeight = 0;
    };

    void scheduleWindowUpdate();
    void initialize();
    void initializePipeline();
    void ensurePreviewTarget(const QSize &size);
    GLuint compileShader(GLenum type, const char *src);
    std::optional<PreviewFrameInfo> currentPreviewFrameFromBridge() const;
    int duplicateBridgeFd(const PreviewFrameInfo &frame, int sourceFd) const;
    uint64_t dmaBufferKeyForFd(int fd) const;
    void connectBridgeSignals(QObject *bridge);
    void ensureImported(const PreviewFrameInfo &frame);
    void cleanupImportedBuffers();
    QRectF previewRectInPixels() const;
    void renderProcessedPreview(const PreviewFrameInfo &frame, const QSize &size);
    void renderDirectToWindow(const PreviewFrameInfo &frame, const QRectF &rect, float winH);
    void blitPreviewToWindow(const QRectF &rect, float winH);

    struct PreviewCacheState
    {
        uint64_t frame = 0;
        QSize size;
        float zoom = 1.0f;
        float panX = 0.0f;
        float panY = 0.0f;
        bool zebraEnabled = false;
        float zebraThreshold = 0.70f;
        bool focusPeakingEnabled = false;
        float focusPeakingThreshold = 0.04f;
        QString focusPeakingColor;
        bool grayscaleEnabled = false;
        bool anamorphicDesqueezeEnabled = false;
        float anamorphicDesqueezeRatio = 1.33f;
        bool falseColorEnabled = false;
        int falseColorMode = 0;
        int displayRotation = 0;
    };

    PreviewCacheState currentPreviewState(const PreviewFrameInfo &frame, const QSize &size) const;
    bool previewStateChanged(const PreviewCacheState &state) const;

    QPointer<CameraPreviewItem> m_item;
    QPointer<QQuickWindow> m_window;
    QObject *m_bridge = nullptr;

    bool m_initialized = false;

    GLuint m_processProgram = 0;
    GLuint m_passthroughProgram = 0;
    GLuint m_vbo = 0;
    GLint m_processPosLoc = -1;
    GLint m_processUvLoc = -1;
    GLint m_processTexLoc = -1;
    GLint m_passthroughPosLoc = -1;
    GLint m_passthroughUvLoc = -1;
    GLint m_passthroughTexLoc = -1;

    // Zebra shader uniforms
    GLint m_uTimeLoc = -1;
    GLint m_uZebraEnabledLoc = -1;
    GLint m_uZebraThresholdLoc = -1;

    GLint m_focusPeakingEnabledLoc = -1;
    GLint m_focusPeakingThresholdLoc = -1;
    GLint m_focusPeakingColorLoc = -1;

    GLint m_grayscaleEnabledLoc = -1;

    GLint m_falseColorEnabledLoc = -1;
    GLint m_falseColorModeLoc = -1;

    QElapsedTimer m_shaderTimer;

    std::unordered_map<uint64_t, ImportedBuffer> m_importedBuffers;
    GLuint m_currentTexture = 0;
    GLuint m_previewTexture = 0;
    GLuint m_previewFbo = 0;
    QSize m_previewSize;
    int m_importedProcId = -1;
    unsigned int m_importedWidth = 0;
    unsigned int m_importedHeight = 0;
    unsigned int m_importedStride = 0;
    unsigned int m_importedCaptureWidth = 0;
    unsigned int m_importedCaptureHeight = 0;
    unsigned int m_loggedImportWidth = 0;
    unsigned int m_loggedImportHeight = 0;
    unsigned int m_loggedImportStride = 0;
    unsigned int m_loggedImportCaptureWidth = 0;
    unsigned int m_loggedImportCaptureHeight = 0;
    unsigned int m_lastImportedSequence = 0;
    bool m_haveImportedSequence = false;
    std::optional<PreviewCacheState> m_previewCacheState;
    bool m_updatePending = false;
    bool m_directWindowRendering = false;
};
