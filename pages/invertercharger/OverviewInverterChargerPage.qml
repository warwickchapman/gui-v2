/*
** Copyright (C) 2023 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

import QtQuick
import Victron.VenusOS

Page {
	id: root

	// serviceUid can be for an inverter, vebus or acsystem service.
	property string serviceUid
	readonly property string serviceType: BackendConnection.serviceTypeFromUid(serviceUid)

	VeQuickItem {
		id: dcCurrent

		uid: root.serviceUid + "/Dc/0/Current"
	}

	VeQuickItem {
		id: dcPower

		uid: root.serviceUid + "/Dc/0/Power"
	}

	VeQuickItem {
		id: dcVoltage

		uid: root.serviceUid + "/Dc/0/Voltage"
	}

	VeQuickItem {
		id: stateOfCharge

		uid: root.serviceUid + "/Soc"
	}

	VeQuickItem {
		id: isInverterChargerItem
		uid: root.serviceUid + "/IsInverterCharger"
	}

	GradientListView {
		model: ObjectModel {
			ListItem {
				id: modeListButton

				text: CommonWords.mode
				writeAccessLevel: VenusOS.User_AccessType_User
				content.children: [
					InverterChargerModeButton {
						width: Math.min(implicitWidth, modeListButton.maximumContentWidth)
						serviceUid: root.serviceUid
					}
				]
			}

			ListTextItem {
				text: CommonWords.state
				secondaryText: Global.system.systemStateToText(dataItem.value)
				dataItem.uid: root.serviceUid + "/State"
			}

			Column {
				width: parent ? parent.width : 0

				Repeater {
					model: AcInputSettingsModel {
						serviceUid: root.serviceUid
					}
					delegate: ListItem {
						id: currentLimitListButton
						writeAccessLevel: VenusOS.User_AccessType_User
						text: Global.acInputs.currentLimitTypeToText(modelData.inputType)
						content.children: [
							CurrentLimitButton {
								width: Math.min(implicitWidth, currentLimitListButton.maximumContentWidth)
								serviceUid: root.serviceUid
								inputNumber: modelData.inputNumber
								inputType: modelData.inputType
							}
						]
					}
				}
			}

			Loader {
				width: parent ? parent.width : 0
				sourceComponent: root.serviceType === "inverter" ? inverterAcOutQuantityGroup
						: root.serviceType === "vebus" ? veBusAcIODisplay
						: root.serviceType === "acsystem" ? rsSystemAcIODisplay
						: null

				Component {
					id: inverterAcOutQuantityGroup
					InverterAcOutQuantityGroup {
						bindPrefix: root.serviceUid
					}
				}

				Component {
					id: veBusAcIODisplay
					VeBusAcIODisplay {
						serviceUid: root.serviceUid
					}
				}

				Component {
					id: rsSystemAcIODisplay
					RsSystemAcIODisplay {
						serviceUid: root.serviceUid
					}
				}
			}

			ActiveAcInputTextItem {
				bindPrefix: root.serviceUid
				allowed: root.serviceType !== "inverter"
			}

			ListQuantityGroup {
				text: CommonWords.dc

				readonly property var _socModel: [
					{ value: CommonWords.soc_with_prefix.arg(stateOfCharge.isValid ? Units.getCombinedDisplayText(VenusOS.Units_Percentage, stateOfCharge.value) : "--") },
				]

				readonly property var _inverterModel: [
					{ value: dcVoltage.value, unit: VenusOS.Units_Volt_DC },
					{ value: dcCurrent.value, unit: VenusOS.Units_Amp }
				]

				readonly property var _inverterChargerModel: [
					{ value: dcPower.value, unit: VenusOS.Units_Watt },
					{ value: dcVoltage.value, unit: VenusOS.Units_Volt_DC },
					{ value: dcCurrent.value, unit: VenusOS.Units_Amp },
				].concat(_socModel)

				textModel: {
					if (root.serviceType === "inverter") {
						if (isInverterChargerItem.value === 1) {
							return _inverterModel.concat(_socModel)
						} else {
							return _inverterModel
						}
					} else {
						return _inverterChargerModel
					}
				}
			}

			ListNavigationItem {
				text: CommonWords.product_page
				onClicked: {
					if (root.serviceType === "inverter") {
						Global.pageManager.pushPage("/pages/settings/devicelist/inverter/PageInverter.qml", { bindPrefix: root.serviceUid })
					} else if (root.serviceType === "vebus") {
						const deviceIndex = Global.inverterChargers.veBusDevices.indexOf(root.serviceUid)
						const device = deviceIndex >= 0 ? Global.inverterChargers.veBusDevices.deviceAt(deviceIndex) : null
						if (device) {
							Global.pageManager.pushPage("/pages/vebusdevice/PageVeBus.qml", { veBusDevice: device })
						} else {
							console.warn("Cannot find vebus object for service:", root.serviceUid)
						}
					} else if (root.serviceType === "acsystem") {
						Global.pageManager.pushPage("/pages/settings/devicelist/rs/PageRsSystem.qml", { bindPrefix: root.serviceUid })
					} else {
						console.warn("Unsupported service:", root.serviceUid)
					}
				}
			}
		}
	}
}
