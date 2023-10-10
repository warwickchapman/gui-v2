/*
** Copyright (C) 2023 Victron Energy B.V.
*/

import QtQuick
import Victron.VenusOS
import Victron.Veutil
import "/components/Utils.js" as Utils

Device {
	id: input

	readonly property int type: _type.value === undefined ? -1 : _type.value
	readonly property int state: _state.value === undefined ? -1 : _state.value

	readonly property VeQuickItem _type: VeQuickItem {
		uid: input.serviceUid + "/Type"
	}

	readonly property VeQuickItem _state: VeQuickItem {
		uid: input.serviceUid + "/State"
	}

	property bool _valid: deviceInstance.value !== undefined
	on_ValidChanged: {
		if (!!Global.digitalInputs) {
			if (_valid) {
				Global.digitalInputs.addInput(input)
			} else {
				Global.digitalInputs.removeInput(input)
			}
		}
	}
}
