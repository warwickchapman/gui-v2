/*
** Copyright (C) 2024 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

import QtQuick
import Victron.VenusOS

DeviceListDelegate {
	id: root

	quantityModel: [
		{ value: activePhaseData.power, unit: activePhaseData.powerUnit }
	]

	onClicked: {
		Global.pageManager.pushPage("/pages/settings/devicelist/inverter/PageInverter.qml",
				{ bindPrefix : root.device.serviceUid })
	}

	AcData {
		id: activePhaseData
		bindPrefix: "%1/Ac/Out/%2".arg(root.device.serviceUid).arg(activePhase.name)
	}

	VeQuickItem {
		id: activePhase

		readonly property string name: value === 2 ? "L3" : (value === 1 ? "L2" : "L1")

		uid: root.device.serviceUid + "/Settings/System/AcPhase"
	}
}
