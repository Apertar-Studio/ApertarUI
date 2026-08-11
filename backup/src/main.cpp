#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QSurfaceFormat>
#include <QSGRendererInterface>
#include <QUrl>
#include <QByteArray>

#include "PreviewWindowRenderer.hpp"
#include "CameraPreviewItem.hpp"
#include "ApertarPreviewSocketClient.hpp"
#include "SystemStatsBridge.hpp"
#include "DeviceInfoBridge.hpp"
#include "SystemActionBridge.hpp"
#include "SleepManager.hpp"
#include "MediaStatusBridge.hpp"
#include "Ina219Bridge.hpp"
#include "WifiBridge.hpp"
#include "AudioDeviceBridge.hpp"
#include "AudioMeterBridge.hpp"
#include "AudioMixerBridge.hpp"
#include "ExternalMonitorManager.hpp"
#include "ApertarControlBridge.hpp"
#include "SettingsBridge.hpp"
#include "cliplistmodel.h"
#include "playbackcontroller.h"
#include "cdngimageprovider.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_UseOpenGLES);
    QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts);
    QQuickWindow::setGraphicsApi(QSGRendererInterface::OpenGL);

    const QByteArray platform = qgetenv("QT_QPA_PLATFORM").toLower();
    if (qEnvironmentVariableIsEmpty("QSG_RENDER_LOOP") && platform == QByteArrayLiteral("eglfs"))
        qputenv("QSG_RENDER_LOOP", QByteArrayLiteral("basic"));

    QSurfaceFormat fmt;
    fmt.setRenderableType(QSurfaceFormat::OpenGLES);
    fmt.setMajorVersion(2);
    fmt.setMinorVersion(0);
    fmt.setProfile(QSurfaceFormat::NoProfile);
    fmt.setSwapBehavior(QSurfaceFormat::DoubleBuffer);
    fmt.setSwapInterval(1);
    QSurfaceFormat::setDefaultFormat(fmt);

    QGuiApplication app(argc, argv);
    app.setApplicationName(QStringLiteral("Apertar-UI"));
    app.setApplicationDisplayName(QStringLiteral("Apertar-UI"));

    qmlRegisterType<CameraPreviewItem>("Apertar", 1, 0, "CameraPreviewItem");

    ApertarPreviewSocketClient apertarPreviewBridge;
    SystemStatsBridge statsBridge;
    DeviceInfoBridge deviceInfoBridge;
    SystemActionBridge systemActionBridge;
    SleepManager sleepManager;
    MediaStatusBridge mediaBridge;
    Ina219Bridge powerBridge(4, 0x40);
    WifiBridge wifiBridge;
    AudioDeviceBridge audioDeviceBridge;
    ApertarControlBridge apertarControlBridge;
    SettingsBridge settings;
    AudioMeterBridge audioMeterBridge;
    AudioMixerBridge audioMixerBridge;
    ClipListModel clipModel;
    PlaybackController playbackController;

    audioDeviceBridge.setSettingsBridge(&settings);
    audioMeterBridge.setSettingsBridge(&settings);
    audioMeterBridge.setControlBridge(&apertarControlBridge);
    audioMixerBridge.setSettingsBridge(&settings);
    playbackController.setSettingsBridge(&settings);

    QQmlApplicationEngine engine;
    auto *cdngProvider = new CdngImageProvider(false, false, false);
    auto *cdngThumbProvider = new CdngImageProvider(true, true, false);
    auto *cdngPlayProvider = new CdngImageProvider(false, true, true);
    engine.addImageProvider(QLatin1String("cdng"), cdngProvider);
    engine.addImageProvider(QLatin1String("cdngthumb"), cdngThumbProvider);
    engine.addImageProvider(QLatin1String("cdngplay"), cdngPlayProvider);
    engine.rootContext()->setContextProperty("apertarPreviewBridge", &apertarPreviewBridge);
    engine.rootContext()->setContextProperty("statsBridge", &statsBridge);
    engine.rootContext()->setContextProperty("deviceInfoBridge", &deviceInfoBridge);
    engine.rootContext()->setContextProperty("systemActionBridge", &systemActionBridge);
    engine.rootContext()->setContextProperty("sleepManager", &sleepManager);
    engine.rootContext()->setContextProperty("mediaBridge", &mediaBridge);
    engine.rootContext()->setContextProperty("powerBridge", &powerBridge);
    engine.rootContext()->setContextProperty("wifiBridge", &wifiBridge);
    engine.rootContext()->setContextProperty("audioDeviceBridge", &audioDeviceBridge);
    engine.rootContext()->setContextProperty("audioMeterBridge", &audioMeterBridge);
    engine.rootContext()->setContextProperty("apertarControlBridge", &apertarControlBridge);
    engine.rootContext()->setContextProperty("settingsBridge", &settings);
    engine.rootContext()->setContextProperty("clipModel", &clipModel);
    engine.rootContext()->setContextProperty("playbackController", &playbackController);
    engine.rootContext()->setContextProperty("cdngThumbProvider", cdngThumbProvider);
    engine.rootContext()->setContextProperty("cdngPlayProvider", cdngPlayProvider);
    engine.load(QUrl(QStringLiteral("qrc:/qml/Main.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    QObject *root = engine.rootObjects().first();
    if (auto *window = qobject_cast<QQuickWindow *>(root)) {
        window->setPersistentGraphics(true);
        window->setPersistentSceneGraph(true);
        if (window->contentItem())
            window->contentItem()->setAcceptTouchEvents(true);
    }
    auto *previewContainer = root->findChild<QQuickItem *>("previewContainer");
    auto *previewItem = root->findChild<CameraPreviewItem *>("previewItem");

    if (previewContainer)
        previewContainer->setAcceptTouchEvents(true);
    if (previewItem)
        previewItem->setAcceptTouchEvents(true);

    auto *renderer = new PreviewWindowRenderer(&engine);
    renderer->setPreviewItem(previewItem);

    ExternalMonitorManager externalMonitorManager(&engine, &engine);
    externalMonitorManager.setMainWindow(qobject_cast<QQuickWindow *>(root));
    externalMonitorManager.setSettingsBridge(&settings);

    return app.exec();
}
