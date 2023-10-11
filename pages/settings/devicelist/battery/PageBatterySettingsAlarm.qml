/*
** Copyright (C) 2023 Victron Energy B.V.
*/

import QtQuick
import Victron.VenusOS
import "/components/Units.js" as Units

Page {
	id: root

	property string bindPrefix

	GradientListView {
		model: ObjectModel {
			// xxxxxxxxxx need to verify these sliders sort of look like gui-v1 versions
			// xxxxxxxxxxx need to make custom RangeSlider from Controls component
			// xxxxxxx and add it to demo gallery!

			ListRangeSlider {
				//% "Low state-of-charge"
				text: qsTrId("batterysettingsalarm_low_state_of_charge")
				suffix: "%"
				first.handle.color: "indianred"
				second.handle.color: "lightgreen"
				firstDataSource: root.bindPrefix + "/Settings/Alarm/LowSoc"
				secondDataSource: root.bindPrefix + "/Settings/Alarm/LowSocClear"
				visible: defaultVisible && dataValid
			}

			ListRangeSlider {
				//% "Low battery voltage"
				text: qsTrId("batterysettingsalarm_low_battery_voltage")
				suffix: "V"
				decimals: 1
				stepSize: 0.1
				first.handle.color: "indianred"
				second.handle.color: "lightgreen"
				firstDataSource: root.bindPrefix + "/Settings/Alarm/LowVoltage"
				secondDataSource: root.bindPrefix + "/Settings/Alarm/LowVoltageClear"
				visible: defaultVisible && dataValid
			}

			ListRangeSlider {
				//% "High battery voltage"
				text: qsTrId("batterysettingsalarm_high_battery_voltage")
				suffix: "V"
				decimals: 1
				stepSize: 0.1
				first.handle.color: "lightgreen"
				second.handle.color: "indianred"
				firstDataSource: root.bindPrefix + "/Settings/Alarm/HighVoltageClear"
				secondDataSource: root.bindPrefix + "/Settings/Alarm/HighVoltage"
				visible: defaultVisible && dataValid
			}

			ListRangeSlider {
				//% "Low starter battery voltage"
				text: qsTrId("batterysettingsalarm_low_starter_battery_voltage")
				suffix: "V"
				decimals: 1
				stepSize: 0.1
				first.handle.color: "indianred"
				second.handle.color: "lightgreen"
				firstDataSource: root.bindPrefix + "/Settings/Alarm/LowStarterVoltage"
				secondDataSource: root.bindPrefix + "/Settings/Alarm/LowStarterVoltageClear"
				visible: defaultVisible && dataValid
			}

			ListRangeSlider {
				//% "High starter battery voltage"
				text: qsTrId("batterysettingsalarm_high_starter_battery_voltage")
				suffix: "V"
				decimals: 1
				stepSize: 0.1
				first.handle.color: "lightgreen"
				second.handle.color: "indianred"
				firstDataSource: root.bindPrefix + "/Settings/Alarm/HighStarterVoltageClear"
				secondDataSource: root.bindPrefix + "/Settings/Alarm/HighStarterVoltage"
				visible: defaultVisible && dataValid
			}

			ListRangeSlider {
				//% "Low battery temperature"
				text: qsTrId("batterysettingsalarm_low_battery_temperature")
				first.handle.color: "indianred"
				second.handle.color: "lightgreen"
				firstDataSource: root.bindPrefix + "/Settings/Alarm/LowBatteryTemperature"
				secondDataSource: root.bindPrefix + "/Settings/Alarm/LowBatteryTemperatureClear"
				visible: defaultVisible && dataValid
				toSourceValue: function(v) {
					return Units.toKelvin(v, Global.systemSettings.temperatureUnit.value)
				}
				fromSourceValue: function(v) {
					return Units.fromKelvin(v, Global.systemSettings.temperatureUnit.value)
				}
			}

			ListRangeSlider {
				//% "High battery temperature"
				text: qsTrId("batterysettingsalarm_high_battery_temperature")
				first.handle.color: "lightgreen"
				second.handle.color: "indianred"
				firstDataSource: root.bindPrefix + "/Settings/Alarm/HighBatteryTemperatureClear"
				secondDataSource: root.bindPrefix + "/Settings/Alarm/HighBatteryTemperature"
				visible: defaultVisible && dataValid
				toSourceValue: function(v) {
					return Units.toKelvin(v, Global.systemSettings.temperatureUnit.value)
				}
				fromSourceValue: function(v) {
					return Units.fromKelvin(v, Global.systemSettings.temperatureUnit.value)
				}
			}
		}
	}
}
