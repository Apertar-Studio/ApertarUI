#include "SettingsBridge.hpp"

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
    m_anamorphicDesqueezeEnabled = m_settings.value("anamorphicDesqueezeEnabled", false).toBool();
    m_anamorphicRatio = m_settings.value("anamorphicRatio", "1.33x").toString();

    m_falseColorEnabled = m_settings.value("falseColorEnabled", false).toBool();
    m_falseColorMode = m_settings.value("falseColorMode", 0).toInt();

    m_guidesEnabled = m_settings.value("guidesEnabled", true).toBool();
    m_guidesType = m_settings.value("guidesType", "Thirds").toString();
    m_guidesThickness = qBound(1, m_settings.value("guidesThickness", 1).toInt(), 4);

    m_centerMarkerEnabled = m_settings.value("centerMarkerEnabled", true).toBool();
    m_centerMarkerType = m_settings.value("centerMarkerType", "Circle/Dot").toString();
    m_externalMonitorEnabled = m_settings.value("externalMonitorEnabled", false).toBool();
    m_externalMonitorMode = normalizeExternalMonitorMode(
        m_settings.value("externalMonitorMode", "Clean Feed").toString());
    m_externalMonitorInfoOverlay = normalizeExternalMonitorInfoOverlay(
        m_settings.value("externalMonitorInfoOverlay", "On").toString());
    m_externalMonitorOrientation = normalizeExternalMonitorOrientation(
        m_settings.value("externalMonitorOrientation", "Landscape").toString());
    m_timecodeMode = m_settings.value("timecodeMode", "Free Run").toString();
    m_photoModeEnabled = m_settings.value("photoModeEnabled", false).toBool();
    m_photoTimer = m_settings.value("photoTimer", "Off").toString();
    m_photoBurst = m_settings.value("photoBurst", "Single").toString();
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
    m_monitoringOrder = m_settings.value("monitoringOrder").toStringList();
    m_recordOrder = m_settings.value("recordOrder").toStringList();
    m_audioOrder = m_settings.value("audioOrder").toStringList();
    m_powerOrder = m_settings.value("powerOrder").toStringList();
    m_systemOrder = m_settings.value("systemOrder").toStringList();
    m_wifiOrder = m_settings.value("wifiOrder").toStringList();
    m_infoOrder = m_settings.value("infoOrder").toStringList();
    m_sidebarOrder = m_settings.value("sidebarOrder").toStringList();
    m_favoritesOrder = m_settings.value("favoritesOrder").toStringList();
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
    emit grayscaleEnabledChanged();
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
