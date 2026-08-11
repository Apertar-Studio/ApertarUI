#include <QGuiApplication>
#include <QFile>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QRect>
#include <QScreen>
#include <QDebug>
#include <QSurfaceFormat>
#include <QSGRendererInterface>
#include <QTimer>
#include <QUrl>
#include <QByteArray>

#include "PreviewWindowRenderer.hpp"
#include "CameraPreviewItem.hpp"
#include "ApertarPreviewSocketClient.hpp"
#include "SystemStatsBridge.hpp"
#include "DeviceInfoBridge.hpp"
#include "DisplayConfigBridge.hpp"
#include "SystemActionBridge.hpp"
#include "PowerButtonBridge.hpp"
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

namespace {

bool screenIsHdmi(const QScreen *screen)
{
    return screen && screen->name().contains(QStringLiteral("HDMI"), Qt::CaseInsensitive);
}

bool screenLooksLikeInternalPanel(const QScreen *screen)
{
    if (!screen || screenIsHdmi(screen))
        return false;

    const QString name = screen->name().toLower();
    const QSize size = screen->geometry().size();
    return name.contains(QStringLiteral("dpi"))
           || name.contains(QStringLiteral("dsi"))
           || name.contains(QStringLiteral("lcd"))
           || name.contains(QStringLiteral("panel"))
           || (size.width() == 720 && size.height() == 720);
}

bool internalTouchPanelPresent()
{
    QFile devices(QStringLiteral("/proc/bus/input/devices"));
    if (!devices.open(QIODevice::ReadOnly | QIODevice::Text))
        return false;

    const QString text = QString::fromLatin1(devices.readAll()).toLower();
    return text.contains(QStringLiteral("touch"))
           || text.contains(QStringLiteral("touchscreen"))
           || text.contains(QStringLiteral("goodix"))
           || text.contains(QStringLiteral("ep0110"))
           || text.contains(QStringLiteral("hyperpixel"))
           || text.contains(QStringLiteral("waveshare"));
}

QScreen *mainUiScreenForNormalMode()
{
    const QList<QScreen *> screens = QGuiApplication::screens();
    if (screens.isEmpty())
        return nullptr;
    if (screens.size() == 1)
        return screens.first();

    QScreen *firstHdmi = nullptr;
    QScreen *firstInternalPanel = nullptr;
    for (QScreen *screen : screens) {
        if (!screen)
            continue;
        if (!firstHdmi && screenIsHdmi(screen))
            firstHdmi = screen;
        if (!firstInternalPanel && screenLooksLikeInternalPanel(screen))
            firstInternalPanel = screen;
    }

    if (firstInternalPanel && (internalTouchPanelPresent() || !firstHdmi))
        return firstInternalPanel;

    if (firstHdmi)
        return firstHdmi;

    if (QScreen *primary = QGuiApplication::primaryScreen())
        return primary;

    return screens.first();
}

} // namespace

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
    DisplayConfigBridge displayConfig;
    const bool hdmiExternalOnly = displayConfig.hdmiExternalOnly();
    qInfo().noquote()
        << QStringLiteral("Apertar display config: path=%1 size=%2x%3 layout=%4 rotation=%5 opacity=%6 windowed=%7 hdmi_external_only=%8")
               .arg(displayConfig.configPath())
               .arg(displayConfig.uiWidth())
               .arg(displayConfig.uiHeight())
               .arg(displayConfig.uiLayout())
               .arg(displayConfig.uiRotationDegrees())
               .arg(QString::number(displayConfig.controlsOpacity(), 'f', 2))
               .arg(displayConfig.windowed() ? QStringLiteral("true") : QStringLiteral("false"))
               .arg(displayConfig.hdmiExternalOnly() ? QStringLiteral("true") : QStringLiteral("false"));

    qmlRegisterType<CameraPreviewItem>("Apertar", 1, 0, "CameraPreviewItem");

    ApertarPreviewSocketClient apertarPreviewBridge;
    SystemStatsBridge statsBridge;
    DeviceInfoBridge deviceInfoBridge;
    SystemActionBridge systemActionBridge;
    PowerButtonBridge powerButtonBridge;
    SleepManager sleepManager;
    MediaStatusBridge mediaBridge;
    Ina219Bridge powerBridge;
    WifiBridge wifiBridge;
    AudioDeviceBridge audioDeviceBridge;
    ApertarControlBridge apertarControlBridge;
    SettingsBridge settings;
    AudioMeterBridge audioMeterBridge;
    AudioMixerBridge audioMixerBridge;
    ClipListModel clipModel;
    PlaybackController playbackController;

    settings.setControlBridge(&apertarControlBridge);
    settings.setDefaultCameraControlsOpacity(displayConfig.controlsOpacity());
    audioDeviceBridge.setSettingsBridge(&settings);
    audioMeterBridge.setSettingsBridge(&settings);
    audioMeterBridge.setControlBridge(&apertarControlBridge);
    QObject::connect(&apertarControlBridge,
                     &ApertarControlBridge::externalRecordingPreparationRequested,
                     &audioMeterBridge,
                     &AudioMeterBridge::releaseInputForRecording);
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
    engine.rootContext()->setContextProperty("displayConfigBridge", &displayConfig);
    engine.rootContext()->setContextProperty("systemActionBridge", &systemActionBridge);
    engine.rootContext()->setContextProperty("powerButtonBridge", &powerButtonBridge);
    engine.rootContext()->setContextProperty("sleepManager", &sleepManager);
    engine.rootContext()->setContextProperty("mediaBridge", &mediaBridge);
    engine.rootContext()->setContextProperty("powerBridge", &powerBridge);
    engine.rootContext()->setContextProperty("wifiBridge", &wifiBridge);
    engine.rootContext()->setContextProperty("audioDeviceBridge", &audioDeviceBridge);
    engine.rootContext()->setContextProperty("audioMeterBridge", &audioMeterBridge);
    engine.rootContext()->setContextProperty("apertarControlBridge", &apertarControlBridge);
    engine.rootContext()->setContextProperty("settingsBridge", &settings);
    engine.rootContext()->setContextProperty("hdmiExternalOnly", hdmiExternalOnly);
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
        if (hdmiExternalOnly) {
            window->hide();
        } else if (QScreen *mainUiScreen = mainUiScreenForNormalMode()) {
            if (window->screen() != mainUiScreen) {
                window->hide();
                window->setScreen(mainUiScreen);
            }
            if (displayConfig.windowed()) {
                const QRect screenGeometry = mainUiScreen->geometry();
                qInfo().noquote()
                    << QStringLiteral("Apertar layout test viewport: screen=%1 screen_geometry=%2,%3 %4x%5 viewport=%6x%7")
                           .arg(mainUiScreen->name(),
                                QString::number(screenGeometry.x()),
                                QString::number(screenGeometry.y()),
                                QString::number(screenGeometry.width()),
                                QString::number(screenGeometry.height()),
                                QString::number(displayConfig.uiWidth()),
                                QString::number(displayConfig.uiHeight()));
                window->setGeometry(screenGeometry);
                window->showFullScreen();
                QTimer::singleShot(250, window, [window]() {
                    if (!window)
                        return;
                    window->showFullScreen();
                    window->raise();
                    window->requestActivate();
                });
            } else {
                window->setGeometry(mainUiScreen->geometry());
                window->showFullScreen();
            }
        }
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
    externalMonitorManager.setHdmiExternalOnly(hdmiExternalOnly && !displayConfig.windowed());
    externalMonitorManager.setMainWindow(qobject_cast<QQuickWindow *>(root));
    if (!displayConfig.windowed())
        externalMonitorManager.setSettingsBridge(&settings);

    return app.exec();
}
