/*
** Copyright (C) 2023 Victron Energy B.V.
*/

import QtQuick
import Victron.VenusOS

Page {
	id: root

	property string bindPrefix

	GradientListView {
		model: ObjectModel {
			ListNavigtionItem {
				//% "Battery bank"
				text: qsTrId("batterysettings_battery_bank")
				onClicked: {
					Global.pageManager.pushPage("/pages/settings/devicelist/battery/PageBatterySettingsBattery.qml",
							{ "title": text, "bindPrefix": root.bindPrefix })
				}
			}

			ListNavigtionItem {
				//% "Alarms"
				text: qsTrId("batterysettings_alarms")
				onClicked: {
					Global.pageManager.pushPage("/pages/settings/devicelist/battery/PageBatterySettingsAlarm.qml",
							{ "title": text, "bindPrefix": root.bindPrefix })
				}
			}

			ListNavigtionItem {
				//% "Relay (on battery monitor)"
				text: qsTrId("batterysettings_relay_on_battery_monitor")
				onClicked: {
					Global.pageManager.pushPage("/pages/settings/devicelist/battery/PageBatterySettingsRelay.qml",
							{ "title": text, "bindPrefix": root.bindPrefix })
				}
			}

			ListRadioButtonGroup {
				//% "Restore factory defaults"
				text: qsTrId("batterysettings_restore_factory_defaults")
				//% "Press to restore"
				secondaryText: qsTrId("batterysettings_press_to_restore")
				dataSource: root.bindPrefix + "/Settings/RestoreDefaults"
				visible: defaultVisible && dataValid
				optionModel: [
					//% "Cancel"
					{ display: qsTrId("batterysettings_cancel"), value: 0 },
					//% "Restore"
					{ display: qsTrId("batterysettings_restore"), value: 1 },
				]
			}

			ListTextItem {
				//% "Bluetooth Enabled"
				text: qsTrId("batterysettings_bluetooth_enabled")
				secondaryText: CommonWords.yesOrNo(dataValue)
				dataSource: root.bindPrefix + "/Settings/BluetoothMode"
				visible: defaultVisible && dataValid
			}
		}
	}
}
