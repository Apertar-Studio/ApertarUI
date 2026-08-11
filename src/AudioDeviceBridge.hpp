#pragma once

#include <QObject>
#include <QPointer>
#include <QHash>
#include <QStringList>
#include <QTimer>

class SettingsBridge;

class AudioDeviceBridge : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QStringList inputDeviceOptions READ inputDeviceOptions NOTIFY inputDeviceOptionsChanged)
    Q_PROPERTY(QStringList outputDeviceOptions READ outputDeviceOptions NOTIFY outputDeviceOptionsChanged)
    Q_PROPERTY(bool hasInputDevices READ hasInputDevices NOTIFY inputDeviceOptionsChanged)
    Q_PROPERTY(bool hasOutputDevices READ hasOutputDevices NOTIFY outputDeviceOptionsChanged)

public:
    struct DeviceSnapshot {
        QStringList labels;
        QHash<QString, QString> labelToId;
        QHash<QString, QString> idToLabel;
    };

    explicit AudioDeviceBridge(QObject *parent = nullptr);

    QStringList inputDeviceOptions() const;
    QStringList outputDeviceOptions() const;
    bool hasInputDevices() const;
    bool hasOutputDevices() const;

    void setSettingsBridge(SettingsBridge *settingsBridge);
    Q_INVOKABLE void setPollingEnabled(bool enabled);
    Q_INVOKABLE void refresh();
    Q_INVOKABLE QString resolvedInputDeviceLabel(const QString &selection) const;
    Q_INVOKABLE QString resolvedOutputDeviceLabel(const QString &selection) const;
    Q_INVOKABLE QString normalizeInputSelection(const QString &selection) const;
    Q_INVOKABLE QString normalizeOutputSelection(const QString &selection) const;
    Q_INVOKABLE QString inputDeviceIdForLabel(const QString &label) const;
    Q_INVOKABLE QString outputDeviceIdForLabel(const QString &label) const;

signals:
    void inputDeviceOptionsChanged();
    void outputDeviceOptionsChanged();

private:
    DeviceSnapshot detectDevices(const QString &tool) const;
    void setInputDevices(const DeviceSnapshot &snapshot);
    void setOutputDevices(const DeviceSnapshot &snapshot);
    QString resolvedDeviceLabel(const QStringList &options,
                                const QHash<QString, QString> &idToLabel,
                                const QString &selection,
                                const QString &placeholder) const;
    QString normalizedSelection(const QStringList &options,
                                const QHash<QString, QString> &labelToId,
                                const QHash<QString, QString> &idToLabel,
                                const QString &selection) const;
    QString deviceIdForLabel(const QHash<QString, QString> &labelToId, const QString &label) const;
    QString remapSelection(const QString &selection,
                           const DeviceSnapshot &snapshot,
                           const QHash<QString, QString> &previousIdToLabel,
                           bool outputMode) const;
    void applyPollingMode();

    QPointer<SettingsBridge> m_settingsBridge;
    QTimer m_refreshTimer;
    bool m_pollingEnabled = false;
    QStringList m_inputDeviceOptions;
    QStringList m_outputDeviceOptions;
    QHash<QString, QString> m_inputLabelToId;
    QHash<QString, QString> m_outputLabelToId;
    QHash<QString, QString> m_inputIdToLabel;
    QHash<QString, QString> m_outputIdToLabel;
};
