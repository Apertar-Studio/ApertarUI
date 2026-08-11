#pragma once

#include <QObject>
#include <QJsonObject>
#include <QLocalSocket>
#include <QSettings>
#include <QString>
#include <QTimer>

class ApertarControlBridge : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString fps READ fps NOTIFY fpsChanged)
    Q_PROPERTY(QString iso READ iso NOTIFY isoChanged)
    Q_PROPERTY(QString shutterAngle READ shutterAngle NOTIFY shutterAngleChanged)
    Q_PROPERTY(QString shutterSpeed READ shutterSpeed NOTIFY shutterSpeedChanged)
    Q_PROPERTY(QString whiteBalance READ whiteBalance NOTIFY whiteBalanceChanged)
    Q_PROPERTY(QString resolution READ resolution NOTIFY resolutionChanged)
    Q_PROPERTY(QString recordingFormat READ recordingFormat NOTIFY recordingFormatChanged)
    Q_PROPERTY(QString autofocusMode READ autofocusMode NOTIFY autofocusModeChanged)
    Q_PROPERTY(QString autofocusRange READ autofocusRange NOTIFY autofocusRangeChanged)
    Q_PROPERTY(QString autofocusSpeed READ autofocusSpeed NOTIFY autofocusSpeedChanged)
    Q_PROPERTY(QString autofocusWindow READ autofocusWindow NOTIFY autofocusWindowChanged)
    Q_PROPERTY(bool recording READ recording NOTIFY recordingChanged)
    Q_PROPERTY(int audioInputLevel READ audioInputLevel NOTIFY audioInputLevelChanged)
    Q_PROPERTY(bool connected READ connected NOTIFY connectedChanged)
    Q_PROPERTY(QString lastError READ lastError NOTIFY lastErrorChanged)

public:
    explicit ApertarControlBridge(QObject *parent = nullptr);

    QString fps() const;
    QString iso() const;
    QString shutterAngle() const;
    QString shutterSpeed() const;
    QString whiteBalance() const;
    QString resolution() const;
    QString recordingFormat() const;
    QString autofocusMode() const;
    QString autofocusRange() const;
    QString autofocusSpeed() const;
    QString autofocusWindow() const;
    bool recording() const;
    int audioInputLevel() const;
    bool connected() const;
    QString lastError() const;

    Q_INVOKABLE void refresh();
    Q_INVOKABLE bool applyFps(const QString &displayValue);
    Q_INVOKABLE bool applyIso(const QString &displayValue);
    Q_INVOKABLE bool applyShutterAngle(const QString &displayValue);
    Q_INVOKABLE bool applyShutterSpeed(const QString &displayValue);
    Q_INVOKABLE bool applyWhiteBalance(const QString &displayValue);
    Q_INVOKABLE bool applyResolution(const QString &displayValue);
    Q_INVOKABLE bool applyRecordingFormat(const QString &displayValue);
    Q_INVOKABLE bool applyTimecodeMode(const QString &displayValue);
    Q_INVOKABLE bool applyAutofocusMode(const QString &displayValue);
    Q_INVOKABLE bool applyAutofocusRange(const QString &displayValue);
    Q_INVOKABLE bool applyAutofocusSpeed(const QString &displayValue);
    Q_INVOKABLE bool applyAutofocusWindow(const QString &displayValue);
    Q_INVOKABLE bool capturePhoto(const QString &format = QString());
    Q_INVOKABLE bool setRecording(bool recording);

signals:
    void fpsChanged();
    void isoChanged();
    void shutterAngleChanged();
    void shutterSpeedChanged();
    void whiteBalanceChanged();
    void resolutionChanged();
    void recordingFormatChanged();
    void autofocusModeChanged();
    void autofocusRangeChanged();
    void autofocusSpeedChanged();
    void autofocusWindowChanged();
    void recordingChanged();
    void audioInputLevelChanged();
    void connectedChanged();
    void lastErrorChanged();
    void externalRecordingPreparationRequested();

private:
    QString audioDeviceIdFromSelection(const QString &displayValue) const;
    void ensureEventSocketConnected();
    void processEventSocketMessages();
    void refreshFromCore();
    void updateRefreshTimer();
    void queuePersistedSettingsSync();
    void loadPersistedCameraSettings();
    void saveCurrentCameraSettings(int shutterUsOverride = -1);
    bool syncPersistedCameraSettingsToCore();
    bool sendCoreCommand(const QString &commandName, const QJsonObject &arguments = {}, QJsonObject *replyObject = nullptr);
    void applyCoreMessage(const QJsonObject &message);
    void applyCoreState(const QJsonObject &state);
    void applyShutterFromMicroseconds(double shutterUs, double fps);
    int shutterUsForAngle(double angle, double fps) const;
    int shutterUsForSpeed(double denominator) const;
    double currentFpsValue() const;

    QString formatFpsValue(double value) const;
    QString formatIsoValue(double value) const;
    QString formatShutterAngleValue(double value) const;
    QString formatShutterSpeedValue(double value) const;
    QString formatResolutionValue(int width, int height) const;
    QString formatRecordingFormatValue(const QString &value) const;
    QString parseTimecodeModeValue(const QString &displayValue) const;
    QString formatAutofocusModeValue(const QString &value) const;
    QString formatAutofocusRangeValue(const QString &value) const;
    QString formatAutofocusSpeedValue(const QString &value) const;
    QString formatAutofocusWindowValue(double x, double y, double width, double height) const;
    QString parseAutofocusModeValue(const QString &displayValue) const;
    QString parseAutofocusRangeValue(const QString &displayValue) const;
    QString parseAutofocusSpeedValue(const QString &displayValue) const;
    bool autofocusWindowPreset(const QString &displayValue, double *x, double *y, double *width, double *height) const;

    double parseFpsValue(const QString &displayValue) const;
    double parseIsoValue(const QString &displayValue) const;
    double parseShutterAngleValue(const QString &displayValue) const;
    double parseShutterSpeedValue(const QString &displayValue) const;
    double parseWhiteBalanceValue(const QString &displayValue) const;
    bool parseResolutionValue(const QString &displayValue, int *width, int *height) const;
    QString parseRecordingFormatValue(const QString &displayValue) const;

    QString compactNumber(double value, int decimals = 3) const;
    void setFps(const QString &value);
    void setIso(const QString &value);
    void setShutterAngle(const QString &value);
    void setShutterSpeed(const QString &value);
    void setWhiteBalance(const QString &value);
    void setResolution(const QString &value);
    void setRecordingFormatValue(const QString &value);
    void setAutofocusModeValue(const QString &value);
    void setAutofocusRangeValue(const QString &value);
    void setAutofocusSpeedValue(const QString &value);
    void setAutofocusWindowValue(const QString &value);
    void setRecordingState(bool value);
    void setAudioInputLevel(int value);
    void setConnected(bool value);
    void setLastError(const QString &value);

    QSettings m_settings;
    QString m_fps = QStringLiteral("24.000");
    QString m_iso = QStringLiteral("800");
    QString m_shutterAngle = QStringLiteral("180°");
    QString m_shutterSpeed = QStringLiteral("1/48");
    QString m_whiteBalance = QStringLiteral("5600K");
    QString m_resolution = QStringLiteral("1920x1080");
    QString m_recordingFormat = QStringLiteral("cDNG");
    QString m_autofocusMode = QStringLiteral("Continuous");
    QString m_autofocusRange = QStringLiteral("Normal");
    QString m_autofocusSpeed = QStringLiteral("Normal");
    QString m_autofocusWindow = QStringLiteral("Center");
    bool m_isoAuto = false;
    bool m_shutterAuto = false;
    bool m_recording = false;
    int m_audioInputLevel = 0;
    bool m_connected = false;
    QString m_lastError;
    QTimer m_retryTimer;
    QLocalSocket m_eventSocket;
    int m_nextCommandId = 1;
    bool m_hasPersistedCameraSettings = false;
    bool m_pendingInitialSettingsSync = false;
    bool m_syncingPersistedSettings = false;
};
