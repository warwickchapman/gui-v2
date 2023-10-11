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
			ListTextItem {
				//% "Charge Voltage Limit (CVL)"
				text: qsTrId("batteryparameters_charge_voltage_limit_cvl")
				dataSource: root.bindPrefix + "/Info/MaxChargeVoltage"
			}

			ListTextItem {
				//% "Charge Current Limit (CCL)"
				text: qsTrId("batteryparameters_charge_current_limit_ccl")
				dataSource: root.bindPrefix + "/Info/MaxChargeCurrent"
			}

			ListTextItem {
				//% "Discharge Current Limit (DCL)"
				text: qsTrId("batteryparameters_discharge_current_limit_dcl")
				dataSource: root.bindPrefix + "/Info/MaxDischargeCurrent"
			}

			ListTextItem {
				//% "Low Voltage Disconnect (always ignored)"
				text: qsTrId("batteryparameters_low_voltage_disconnect_always_ignored")
				dataSource: root.bindPrefix + "/Info/BatteryLowVoltage"
				showAccessLevel: VenusOS.User_AccessType_Service
			}
		}
	}
}
