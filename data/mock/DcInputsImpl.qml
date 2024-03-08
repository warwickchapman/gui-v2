/*
** Copyright (C) 2023 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

import QtQuick
import Victron.VenusOS

QtObject {
	id: root

	property int mockDeviceCount
	property var _createdObjects: []

	function populate() {
		// Add a random set of DC inputs.
		// Have 2 inputs at most, to leave some space for AC inputs in overview page
		const serviceTypes = ["alternator", "fuelcell", "dcsource"]
		const modelCount = Math.floor(Math.random() * 2) + 1
		for (let i = 0; i < modelCount; ++i) {
			const typeIndex = Math.floor(Math.random() * serviceTypes.length)
			createInput({ serviceType: serviceTypes[typeIndex]})
		}
	}

	property Connections mockConn: Connections {
		target: Global.mockDataSimulator || null

		function onSetDcInputsRequested(config) {
			Global.dcInputs.reset()
			while (_createdObjects.length > 0) {
				_createdObjects.pop().destroy()
			}

			if (config) {
				for (let i = 0; i < config.types.length; ++i) {
					let inputConfig = config.types[i]
					if (inputConfig) {
						createInput(inputConfig)
					}
				}
			}
		}
	}

	function createInput(props) {
		if (!props.serviceType) {
			console.warn("Cannot create mock DC device without service type! Properties are:", JSON.stringify(props))
			return
		}
		const input = inputComponent.createObject(root, { serviceType: props.serviceType })
		for (let name in props) {
			if (name !== "serviceType") {
				input["_" + name].setValue(props[name])
			}
		}
		if (props.serviceType === "alternator" && props.productId === undefined) {
			// Set a generic product id so that PageAlternator can show a valid page.
			input._productId.setValue(0xB091)
		}
		_createdObjects.push(input)
	}

	property Component inputComponent: Component {
		DcInput {
			id: input

			property string serviceType

			// Set a non-empty uid to avoid bindings to empty serviceUid before Component.onCompleted is called
			serviceUid: "mock/com.victronenergy.dummy"

			property Timer _dummyValues: Timer {
				running: Global.mockDataSimulator.timersActive
				repeat: true
				interval: 10000 + (Math.random() * 10000)
				triggeredOnStart: true

				onTriggered: {
					let properties = ["power", "voltage", "current", "temperature"]
					for (let propIndex = 0; propIndex < properties.length; ++propIndex) {
						let propTotal = 0
						const propName = properties[propIndex]
						let value = 0
						if (propName === "power") {
							value = 50 + Math.random() * 10
						} else if (propName === "voltage") {
							value = 20 + Math.random() * 10
						} else if (propName === "current") {
							value = 1 + Math.random()
						} else if (propName === "temperature") {
							value = 50 + Math.random() * 50
						} else {
							console.warn("Unhandled property", propName)
						}
						input["_" + propName].setValue(value)
					}
				}
			}

			property VeQuickItem _productId: VeQuickItem {
				uid: input.serviceUid + "/ProductId"
				onValueChanged: {
					if (value === 0xA3F0) {
						initOrionXSValues()
					}
				}
			}

			function setMockValue(key, value) {
				Global.mockDataSimulator.setMockValue(serviceUid + key, value)
			}

			function initOrionXSValues() {
				setMockValue("/Mode", 1)
				setMockValue("/State", 1)

				setMockValue("/History/Cumulative/User/OperationTime", 60)  // seconds
				setMockValue("/History/Cumulative/User/ChargedAh", 100)
				setMockValue("/History/Cumulative/User/CyclesStarted", 3)
				setMockValue("/History/Cumulative/User/CyclesCompleted", 2)
				setMockValue("/History/Cumulative/User/NrOfPowerups", 50)
				setMockValue("/History/Cumulative/User/NrOfDeepDischarges", 5)
				setMockValue("/History/Cycle/CyclesAvailable", 1)

				setMockValue("/History/Cycle/TerminationReason", 7)
				setMockValue("/History/Cycle/BulkTime", 2 * 60)
				setMockValue("/History/Cycle/BulkCharge", 30)
				setMockValue("/History/Cycle/AbsorptionCharge", 40)
				setMockValue("/History/Cycle/StartVoltage", 10.5)
				setMockValue("/History/Cycle/EndVoltage", 20.25)
				setMockValue("/History/Cycle/Error", 1)
			}

			Component.onCompleted: {
				const deviceInstanceNum = root.mockDeviceCount++
				serviceUid = "mock/com.victronenergy." + serviceType + ".ttyUSB" + deviceInstanceNum
				_deviceInstance.setValue(deviceInstanceNum)
				_productName.setValue("DC Input Product: " + serviceType)
			}
		}
	}

	Component.onCompleted: {
		populate()
	}
}
