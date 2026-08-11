#pragma once

#include <QObject>
#include <QPointer>

class QQmlApplicationEngine;
class QQuickWindow;
class QScreen;
class CameraPreviewItem;
class PreviewWindowRenderer;
class SettingsBridge;

class ExternalMonitorManager : public QObject
{
    Q_OBJECT

public:
    explicit ExternalMonitorManager(QQmlApplicationEngine *engine, QObject *parent = nullptr);

    void setMainWindow(QQuickWindow *window);
    void setSettingsBridge(SettingsBridge *settings);

private slots:
    void syncWindow();

private:
    bool mainUiAllowsExternalMonitor() const;
    QScreen *externalScreen() const;
    void ensureWindow(QScreen *screen);
    void destroyWindow();

    QPointer<QQmlApplicationEngine> m_engine;
    QPointer<QQuickWindow> m_mainWindow;
    QPointer<SettingsBridge> m_settings;
    QPointer<QQuickWindow> m_externalWindow;
    QPointer<CameraPreviewItem> m_externalPreviewItem;
    PreviewWindowRenderer *m_renderer = nullptr;
};
