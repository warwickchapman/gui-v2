/*
** Copyright (C) 2024 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

import QtQuick
import Victron.VenusOS

DeviceListDelegate {
	id: root

	readonly property var _powerAndStatusModel: [
		{ value: Global.acInputs.gensetStatusCodeToText(statusCode.value), unit: VenusOS.Units_None },
		{ value: power.value, unit: VenusOS.Units_Watt },
	]

	readonly property var _powerModel: [
		{ value: power.value, unit: VenusOS.Units_Watt }
	]

	quantityModel: statusCode.isValid ? _powerAndStatusModel : _powerModel

	onClicked: {
		Global.pageManager.pushPage("/pages/settings/devicelist/ac-in/PageAcIn.qml",
				{ bindPrefix : root.device.serviceUid })
	}

	VeQuickItem {
		id: power
		uid: root.device.serviceUid + "/Ac/Power"
	}

	VeQuickItem {
		id: statusCode
		uid: root.device.serviceUid + "/StatusCode"
	}
}
