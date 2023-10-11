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
			ListAlarmItem {
				//% "Low battery voltage"
				text: qsTrId("battery_low_battery_voltage")
				dataSource: root.bindPrefix + "/Alarms/LowVoltage"
				visible: defaultVisible && dataValid
			}

			ListAlarmItem {
				//% "High battery voltage"
				text: qsTrId("batteryalarms_high_battery_voltage")
				dataSource: root.bindPrefix + "/Alarms/HighVoltage"
				visible: defaultVisible && dataValid
			}

			ListAlarmItem {
				//% "High charge current"
				text: qsTrId("batteryalarms_high_charge_current")
				dataSource: root.bindPrefix + "/Alarms/HighChargeCurrent"
				visible: defaultVisible && dataValid
			}

			ListAlarmItem {
				//% "High discharge current"
				text: qsTrId("batteryalarms_high_discharge_current")
				dataSource: root.bindPrefix + "/Alarms/HighDischargeCurrent"
				visible: defaultVisible && dataValid
			}

			ListAlarmItem {
				//% "Low SOC"
				text: qsTrId("batteryalarms_low_soc")
				dataSource: root.bindPrefix + "/Alarms/LowSoc"
				visible: defaultVisible && dataValid
			}

			ListAlarmItem {
				//% "State of health"
				text: qsTrId("batteryalarms_state_of_health")
				dataSource: root.bindPrefix + "/Alarms/StateOfHealth"
				visible: defaultVisible && dataValid
			}

			ListAlarmItem {
				//% "Low starter voltage"
				text: qsTrId("batteryalarms_low_starter_voltage")
				dataSource: root.bindPrefix + "/Alarms/LowStarterVoltage"
				visible: defaultVisible && dataValid
			}

			ListAlarmItem {
				//% "High starter voltage"
				text: qsTrId("batteryalarms_high_starter_voltage")
				dataSource: root.bindPrefix + "/Alarms/HighStarterVoltage"
				visible: defaultVisible && dataValid
			}

			ListAlarmItem {
				//% "Low temperature"
				text: qsTrId("batteryalarms_low_temperature")
				dataSource: root.bindPrefix + "/Alarms/LowTemperature"
				visible: defaultVisible && dataValid
			}

			ListAlarmItem {
				//% "High temperature"
				text: qsTrId("batteryalarms_high_temperature")
				dataSource: root.bindPrefix + "/Alarms/HighTemperature"
				visible: defaultVisible && dataValid
			}

			ListAlarmItem {
				//% "Battery temperature sensor"
				text: qsTrId("batteryalarms_battery_temperature_sensor")
				dataSource: root.bindPrefix + "/Alarms/BatteryTemperatureSensor"
				visible: defaultVisible && dataValid
			}

			ListAlarmItem {
				//% "Mid-point voltage"
				text: qsTrId("batteryalarms_mid_point_voltage")
				dataSource: root.bindPrefix + "/Alarms/MidVoltage"
				visible: defaultVisible && dataValid
			}

			ListAlarmItem {
				//% "Fuse blown"
				text: qsTrId("batteryalarms_fuse_blown")
				dataSource: root.bindPrefix + "/Alarms/FuseBlown"
				visible: defaultVisible && dataValid
			}

			ListAlarmItem {
				//% "High internal temperature"
				text: qsTrId("batteryalarms_high_internal_temperature")
				dataSource: root.bindPrefix + "/Alarms/HighInternalTemperature"
				visible: defaultVisible && dataValid
			}

			ListAlarmItem {
				//% "Low charge temperature"
				text: qsTrId("batteryalarms_low_charge_temperature")
				dataSource: root.bindPrefix + "/Alarms/LowChargeTemperature"
				visible: defaultVisible && dataValid
			}

			ListAlarmItem {
				//% "High charge temperature"
				text: qsTrId("batteryalarms_high_charge_temperature")
				dataSource: root.bindPrefix + "/Alarms/HighChargeTemperature"
				visible: defaultVisible && dataValid
			}

			ListAlarmItem {
				//% "Internal failure"
				text: qsTrId("batteryalarms_internal_failure")
				dataSource: root.bindPrefix + "/Alarms/InternalFailure"
				visible: defaultVisible && dataValid
			}

			ListAlarmItem {
				//% "Circuit breaker tripped"
				text: qsTrId("batteryalarms_circuit_breaker_tripped")
				dataSource: "com.victronenergy.system/Dc/Battery/Alarms/CircuitBreakerTripped"
				visible: defaultVisible && dataValid
			}

			ListAlarmItem {
				//% "Cell imbalance"
				text: qsTrId("batteryalarms_cell_imbalance")
				dataSource: root.bindPrefix + "/Alarms/CellImbalance"
				visible: defaultVisible && dataValid
			}

			ListAlarmItem {
				//% "Low cell voltage"
				text: qsTrId("batteryalarms_low_cell_voltage")
				dataSource: root.bindPrefix + "/Alarms/LowCellVoltage"
				visible: defaultVisible && dataValid
			}
		}
	}
}
