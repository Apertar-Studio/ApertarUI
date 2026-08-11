#pragma once

#include <QObject>
#include <QSettings>

class SettingsBridge : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool zebraEnabled READ zebraEnabled WRITE setZebraEnabled NOTIFY zebraEnabledChanged)
    Q_PROPERTY(float zebraThreshold READ zebraThreshold WRITE setZebraThreshold NOTIFY zebraThresholdChanged)

    Q_PROPERTY(bool focusPeakingEnabled READ focusPeakingEnabled WRITE setFocusPeakingEnabled NOTIFY focusPeakingEnabledChanged)
    Q_PROPERTY(float focusPeakingThreshold READ focusPeakingThreshold WRITE setFocusPeakingThreshold NOTIFY focusPeakingThresholdChanged)

    Q_PROPERTY(QString focusPeakingColor READ focusPeakingColor WRITE setFocusPeakingColor NOTIFY focusPeakingColorChanged)

    Q_PROPERTY(bool grayscaleEnabled READ grayscaleEnabled WRITE setGrayscaleEnabled NOTIFY grayscaleEnabledChanged)
    Q_PROPERTY(bool anamorphicDesqueezeEnabled READ anamorphicDesqueezeEnabled WRITE setAnamorphicDesqueezeEnabled NOTIFY anamorphicDesqueezeEnabledChanged)
    Q_PROPERTY(QString anamorphicRatio READ anamorphicRatio WRITE setAnamorphicRatio NOTIFY anamorphicRatioChanged)

    Q_PROPERTY(bool falseColorEnabled READ falseColorEnabled WRITE setFalseColorEnabled NOTIFY falseColorEnabledChanged)
    Q_PROPERTY(int falseColorMode READ falseColorMode WRITE setFalseColorMode NOTIFY falseColorModeChanged)

    Q_PROPERTY(bool guidesEnabled READ guidesEnabled WRITE setGuidesEnabled NOTIFY guidesEnabledChanged)
    Q_PROPERTY(QString guidesType READ guidesType WRITE setGuidesType NOTIFY guidesTypeChanged)
    Q_PROPERTY(int guidesThickness READ guidesThickness WRITE setGuidesThickness NOTIFY guidesThicknessChanged)
    Q_PROPERTY(bool centerMarkerEnabled READ centerMarkerEnabled WRITE setCenterMarkerEnabled NOTIFY centerMarkerEnabledChanged)
    Q_PROPERTY(QString centerMarkerType READ centerMarkerType WRITE setCenterMarkerType NOTIFY centerMarkerTypeChanged)
    Q_PROPERTY(bool externalMonitorEnabled READ externalMonitorEnabled WRITE setExternalMonitorEnabled NOTIFY externalMonitorEnabledChanged)
    Q_PROPERTY(QString externalMonitorMode READ externalMonitorMode WRITE setExternalMonitorMode NOTIFY externalMonitorModeChanged)
    Q_PROPERTY(QString externalMonitorInfoOverlay READ externalMonitorInfoOverlay WRITE setExternalMonitorInfoOverlay NOTIFY externalMonitorInfoOverlayChanged)
    Q_PROPERTY(QString externalMonitorOrientation READ externalMonitorOrientation WRITE setExternalMonitorOrientation NOTIFY externalMonitorOrientationChanged)
    Q_PROPERTY(QString timecodeMode READ timecodeMode WRITE setTimecodeMode NOTIFY timecodeModeChanged)
    Q_PROPERTY(bool photoModeEnabled READ photoModeEnabled WRITE setPhotoModeEnabled NOTIFY photoModeEnabledChanged)
    Q_PROPERTY(QString photoTimer READ photoTimer WRITE setPhotoTimer NOTIFY photoTimerChanged)
    Q_PROPERTY(QString photoBurst READ photoBurst WRITE setPhotoBurst NOTIFY photoBurstChanged)
    Q_PROPERTY(bool recordAudioEnabled READ recordAudioEnabled WRITE setRecordAudioEnabled NOTIFY recordAudioEnabledChanged)
    Q_PROPERTY(bool liveAudioMonitoringEnabled READ liveAudioMonitoringEnabled WRITE setLiveAudioMonitoringEnabled NOTIFY liveAudioMonitoringEnabledChanged)
    Q_PROPERTY(bool audioMeterEnabled READ audioMeterEnabled WRITE setAudioMeterEnabled NOTIFY audioMeterEnabledChanged)
    Q_PROPERTY(QString audioInputDevice READ audioInputDevice WRITE setAudioInputDevice NOTIFY audioInputDeviceChanged)
    Q_PROPERTY(QString audioOutputDevice READ audioOutputDevice WRITE setAudioOutputDevice NOTIFY audioOutputDeviceChanged)
    Q_PROPERTY(int inputVolume READ inputVolume WRITE setInputVolume NOTIFY inputVolumeChanged)
    Q_PROPERTY(int headphoneVolume READ headphoneVolume WRITE setHeadphoneVolume NOTIFY headphoneVolumeChanged)
    Q_PROPERTY(QString batteryCapacity READ batteryCapacity WRITE setBatteryCapacity NOTIFY batteryCapacityChanged)
    Q_PROPERTY(int customBatteryWh READ customBatteryWh WRITE setCustomBatteryWh NOTIFY customBatteryWhChanged)
    Q_PROPERTY(QString sleepMode READ sleepMode WRITE setSleepMode NOTIFY sleepModeChanged)
    Q_PROPERTY(QStringList monitoringOrder READ monitoringOrder WRITE setMonitoringOrder NOTIFY monitoringOrderChanged)
    Q_PROPERTY(QStringList recordOrder READ recordOrder WRITE setRecordOrder NOTIFY recordOrderChanged)
    Q_PROPERTY(QStringList audioOrder READ audioOrder WRITE setAudioOrder NOTIFY audioOrderChanged)
    Q_PROPERTY(QStringList powerOrder READ powerOrder WRITE setPowerOrder NOTIFY powerOrderChanged)
    Q_PROPERTY(QStringList systemOrder READ systemOrder WRITE setSystemOrder NOTIFY systemOrderChanged)
    Q_PROPERTY(QStringList wifiOrder READ wifiOrder WRITE setWifiOrder NOTIFY wifiOrderChanged)
    Q_PROPERTY(QStringList infoOrder READ infoOrder WRITE setInfoOrder NOTIFY infoOrderChanged)
    Q_PROPERTY(QStringList sidebarOrder READ sidebarOrder WRITE setSidebarOrder NOTIFY sidebarOrderChanged)
    Q_PROPERTY(QStringList favoritesOrder READ favoritesOrder WRITE setFavoritesOrder NOTIFY favoritesOrderChanged)

public:
    explicit SettingsBridge(QObject *parent = nullptr);

    bool zebraEnabled() const;
    void setZebraEnabled(bool value);

    float zebraThreshold() const;
    void setZebraThreshold(float value);

    bool focusPeakingEnabled() const;
    void setFocusPeakingEnabled(bool value);

    float focusPeakingThreshold() const;
    void setFocusPeakingThreshold(float value);

    QString focusPeakingColor() const;
    void setFocusPeakingColor(const QString &value);

    bool grayscaleEnabled() const;
    void setGrayscaleEnabled(bool value);

    bool anamorphicDesqueezeEnabled() const;
    void setAnamorphicDesqueezeEnabled(bool value);

    QString anamorphicRatio() const;
    void setAnamorphicRatio(const QString &value);

    bool falseColorEnabled() const;
    void setFalseColorEnabled(bool value);

    int falseColorMode() const;
    void setFalseColorMode(int value);

    bool guidesEnabled() const;
    void setGuidesEnabled(bool value);

    QString guidesType() const;
    void setGuidesType(const QString &value);

    int guidesThickness() const;
    void setGuidesThickness(int value);

    bool centerMarkerEnabled() const;
    void setCenterMarkerEnabled(bool value);

    QString centerMarkerType() const;
    void setCenterMarkerType(const QString &value);

    bool externalMonitorEnabled() const;
    void setExternalMonitorEnabled(bool value);

    QString externalMonitorMode() const;
    void setExternalMonitorMode(const QString &value);

    QString externalMonitorInfoOverlay() const;
    void setExternalMonitorInfoOverlay(const QString &value);

    QString externalMonitorOrientation() const;
    void setExternalMonitorOrientation(const QString &value);

    QString timecodeMode() const;
    void setTimecodeMode(const QString &value);

    bool photoModeEnabled() const;
    void setPhotoModeEnabled(bool value);

    QString photoTimer() const;
    void setPhotoTimer(const QString &value);

    QString photoBurst() const;
    void setPhotoBurst(const QString &value);

    bool recordAudioEnabled() const;
    void setRecordAudioEnabled(bool value);

    bool liveAudioMonitoringEnabled() const;
    void setLiveAudioMonitoringEnabled(bool value);

    bool audioMeterEnabled() const;
    void setAudioMeterEnabled(bool value);

    QString audioInputDevice() const;
    void setAudioInputDevice(const QString &value);

    QString audioOutputDevice() const;
    void setAudioOutputDevice(const QString &value);

    int inputVolume() const;
    void setInputVolume(int value);

    int headphoneVolume() const;
    void setHeadphoneVolume(int value);

    QString batteryCapacity() const;
    void setBatteryCapacity(const QString &value);

    int customBatteryWh() const;
    void setCustomBatteryWh(int value);

    QString sleepMode() const;
    void setSleepMode(const QString &value);

    QStringList monitoringOrder() const;
    void setMonitoringOrder(const QStringList &value);

    QStringList recordOrder() const;
    void setRecordOrder(const QStringList &value);

    QStringList audioOrder() const;
    void setAudioOrder(const QStringList &value);

    QStringList powerOrder() const;
    void setPowerOrder(const QStringList &value);

    QStringList systemOrder() const;
    void setSystemOrder(const QStringList &value);

    QStringList wifiOrder() const;
    void setWifiOrder(const QStringList &value);

    QStringList infoOrder() const;
    void setInfoOrder(const QStringList &value);

    QStringList sidebarOrder() const;
    void setSidebarOrder(const QStringList &value);

    QStringList favoritesOrder() const;
    void setFavoritesOrder(const QStringList &value);

signals:
    void zebraEnabledChanged();
    void zebraThresholdChanged();

    void focusPeakingEnabledChanged();
    void focusPeakingThresholdChanged();

    void focusPeakingColorChanged();

    void grayscaleEnabledChanged();
    void anamorphicDesqueezeEnabledChanged();
    void anamorphicRatioChanged();

    void falseColorEnabledChanged();
    void falseColorModeChanged();

    void guidesEnabledChanged();
    void guidesTypeChanged();
    void guidesThicknessChanged();

    void centerMarkerEnabledChanged();
    void centerMarkerTypeChanged();
    void externalMonitorEnabledChanged();
    void externalMonitorModeChanged();
    void externalMonitorInfoOverlayChanged();
    void externalMonitorOrientationChanged();
    void timecodeModeChanged();
    void photoModeEnabledChanged();
    void photoTimerChanged();
    void photoBurstChanged();
    void recordAudioEnabledChanged();
    void liveAudioMonitoringEnabledChanged();
    void audioMeterEnabledChanged();
    void audioInputDeviceChanged();
    void audioOutputDeviceChanged();
    void inputVolumeChanged();
    void headphoneVolumeChanged();
    void batteryCapacityChanged();
    void customBatteryWhChanged();
    void sleepModeChanged();
    void monitoringOrderChanged();
    void recordOrderChanged();
    void audioOrderChanged();
    void powerOrderChanged();
    void systemOrderChanged();
    void wifiOrderChanged();
    void infoOrderChanged();
    void sidebarOrderChanged();
    void favoritesOrderChanged();

private:
    QSettings m_settings;

    bool m_zebraEnabled = false;
    float m_zebraThreshold = 0.70f;

    bool m_focusPeakingEnabled = false;
    float m_focusPeakingThreshold = 0.04f;

    QString m_focusPeakingColor = "Red";

    bool m_grayscaleEnabled = false;
    bool m_anamorphicDesqueezeEnabled = false;
    QString m_anamorphicRatio = "1.33x";

    bool m_falseColorEnabled = false;
    int m_falseColorMode = 0;

    bool m_guidesEnabled = true;
    QString m_guidesType = "Thirds";
    int m_guidesThickness = 1;

    bool m_centerMarkerEnabled = true;
    QString m_centerMarkerType = "Circle/Dot";
    bool m_externalMonitorEnabled = false;
    QString m_externalMonitorMode = "Clean Feed";
    QString m_externalMonitorInfoOverlay = "On";
    QString m_externalMonitorOrientation = "Landscape";
    QString m_timecodeMode = "Free Run";
    bool m_photoModeEnabled = false;
    QString m_photoTimer = "Off";
    QString m_photoBurst = "Single";
    bool m_recordAudioEnabled = false;
    bool m_liveAudioMonitoringEnabled = true;
    bool m_audioMeterEnabled = false;
    QString m_audioInputDevice;
    QString m_audioOutputDevice;
    int m_inputVolume = 60;
    int m_headphoneVolume = 55;
    QString m_batteryCapacity = "150Wh";
    int m_customBatteryWh = 150;
    QString m_sleepMode = "Off";
    QStringList m_monitoringOrder;
    QStringList m_recordOrder;
    QStringList m_audioOrder;
    QStringList m_powerOrder;
    QStringList m_systemOrder;
    QStringList m_wifiOrder;
    QStringList m_infoOrder;
    QStringList m_sidebarOrder;
    QStringList m_favoritesOrder;
};
