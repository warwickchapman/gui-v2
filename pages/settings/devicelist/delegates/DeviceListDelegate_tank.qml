/*
** Copyright (C) 2024 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

import QtQuick
import Victron.VenusOS

DeviceListDelegate {
	id: root

	readonly property var _quantityModel: [
		{ unit: VenusOS.Units_Percentage, value: level.value },
		{ unit: Global.systemSettings.temperatureUnit, value: temperature.value }
	]

	secondaryText: level.isValid ? "" : (status.isValid ? Global.tanks.statusToText(status.value) : "--")
	quantityModel: level.isValid ? _quantityModel : null

	onClicked: {
		Global.pageManager.pushPage("/pages/settings/devicelist/tank/PageTankSensor.qml",
				{ bindPrefix : root.device.serviceUid })
	}

	VeQuickItem {
		id: temperature
		uid: root.device.serviceUid + "/Temperature"
		sourceUnit: Units.unitToVeUnit(VenusOS.Units_Temperature_Celsius)
		displayUnit: Units.unitToVeUnit(Global.systemSettings.temperatureUnit)
	}

	VeQuickItem {
		id: level
		uid: root.device.serviceUid + "/Level"
	}

	VeQuickItem {
		id: status
		uid: root.device.serviceUid + "/Status"
	}
}
