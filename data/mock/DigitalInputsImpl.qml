/*
** Copyright (C) 2023 Victron Energy B.V.
*/

import QtQuick
import Victron.VenusOS

Item {
	id: root

	function populate() {
		const inputCount = (Math.random() * 3) + 1
		for (let i = 0; i < inputCount; ++i) {
			const inputObj = inputComponent.createObject(root, {
				type: Math.random() * VenusOS.DigitalInput_Type_Generator,
				state: Math.random() * VenusOS.DigitalInput_Status_Stopped
			})
			Global.digitalInputs.addInput(inputObj)
		}
	}

	property int _objectId
	property Component inputComponent: Component {
		MockDevice {
			property int type
			property int state

			name: "DigitalInput" + deviceInstance.value
			Component.onCompleted: deviceInstance.value = root._objectId++
		}
	}

	Component.onCompleted: {
		populate()
	}
}
