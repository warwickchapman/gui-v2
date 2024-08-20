/*
** Copyright (C) 2024 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

import QtQuick
import Victron.VenusOS

Label {
	id: root

	readonly property int runtime: runtimeItem.value || 0
	property string serviceUid

	font.pixelSize: Theme.font_size_body2
	color: runtimeItem.isValid ? Theme.color_font_primary : Theme.color_font_secondary
	rightPadding: suffixLabel.width

	// When generator runtime < 60 it has second precision, otherwise when >= 60, it is only
	// updated every minute. So, show mm:ss when < 60, and hh:mm when >= 60.
	text: stateItem.value === VenusOS.Generators_State_Stopped || !runtimeItem.isValid ? "--:--"
		  : (runtime < 60 ? Utils.formatAsHHMMSS(runtime) : Utils.formatAsHHMM(runtime))

	VeQuickItem {
		id: stateItem
		uid: root.serviceUid + "/State"
	}

	VeQuickItem {
		id: runtimeItem
		uid: root.serviceUid + "/Runtime"
	}

	Label {
		id: suffixLabel

		anchors.right: parent.right
		text: stateItem.value === VenusOS.Generators_State_Stopped || !runtimeItem.isValid ? ""
			: runtime < 60
				  //: Abbreviation of "minute"
				  //% "m"
				? qsTrId("generator_runtime_minute")
				  //: Abbreviation of "hour"
				  //% "hr"
				: qsTrId("generator_runtime_hour")
		font.pixelSize: parent.font.pixelSize
		color: Theme.color_font_secondary
	}
}
