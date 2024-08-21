/*
** Copyright (C) 2024 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

import QtQuick
import Victron.VenusOS

DeviceListDelegate {
	id: root

	quantityModel: [
		{
			unit: VenusOS.Units_None,
			value: Global.evChargers.chargerModeToText(mode.value)
		},
		{
			unit: VenusOS.Units_Watt,
			value: power.value,
			visible: status.value === VenusOS.Evcs_Status_Charging
		},
		{
			unit: VenusOS.Units_None,
			value: Global.evChargers.chargerStatusToText(status.value),
			visible: status.value !== VenusOS.Evcs_Status_Charging
		}
	]

	onClicked: {
		const evCharger = sourceModel.deviceAt(sourceModel.indexOf(root.device.serviceUid))
		Global.pageManager.pushPage("/pages/evcs/EvChargerPage.qml", { evCharger : evCharger })
	}

	VeQuickItem {
		id: mode
		uid: root.device.serviceUid + "/Mode"
	}

	VeQuickItem {
		id: status
		uid: root.device.serviceUid + "/Status"
	}

	VeQuickItem {
		id: power
		uid: root.device.serviceUid + "/Ac/Power"
	}
}
