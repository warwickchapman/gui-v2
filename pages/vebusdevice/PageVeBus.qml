/*
** Copyright (C) 2023 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

import QtQuick
import Victron.VenusOS

Page {
	id: root

	property var veBusDevice
	readonly property bool isMulti: veBusDevice.numberOfAcInputs > 0
	readonly property bool chargeInProcess: preferRenewableEnergy.value === 0

	title: veBusDevice.name

	VeQuickItem {
		id: _numberOfPhases

		uid: veBusDevice.serviceUid + "/Ac/NumberOfPhases"
	}

	VeQuickItem {
		id: bmsMode

		uid: veBusDevice.serviceUid + "/Devices/Bms/Version"
	}

	VeQuickItem {
		id: bmsType

		uid: veBusDevice.serviceUid + "/Bms/BmsType"
	}

	VeQuickItem {
		id: bmsExpected

		uid: veBusDevice.serviceUid + "/Bms/BmsExpected"
	}

	VeQuickItem {
		id: dmc

		uid: root.veBusDevice.serviceUid + "/Devices/Dmc/Version"
	}

	VeQuickItem {
		id: mkVersion

		uid: root.veBusDevice.serviceUid + "/Interfaces/Mk2/Version"
	}

	VeQuickItem {
		id: mk3Update

		uid: Global.systemSettings.serviceUid + "/Settings/Vebus/AllowMk3Fw212Update"
	}

	VeQuickItem {
		id: preferRenewableEnergy

		uid: root.veBusDevice.serviceUid + "/Dc/0/PreferRenewableEnergy"
	}

	VeQuickItem {
		id: firmwareVersion
		uid: root.veBusDevice.serviceUid + "/FirmwareVersion"
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
						serviceUid: root.veBusDevice.serviceUid
					}
				]
			}

			ListTextItem {
				text: CommonWords.state
				secondaryText: Global.system.systemStateToText(Global.system.state)
			}

			ListLabel {
				id: mk3firmware

				function doUpdate() { mk3Update.setValue(1) }

				//% "A new MK3 version is available.\nNOTE: The update might temporarily stop the system."
				text: qsTrId("vebus_mk3_new_version_available")
				allowed: mkVersion.value === 1170212 && mk3Update.value === 0
			}

			ListButton {
				//% "Update the MK3"
				text: qsTrId("vebus_device_update_the_mk3")
				//% "Press to update"
				secondaryText: qsTrId("vebus_device_press_to_update")
				allowed: mk3firmware.visible
				onClicked: {
					//% "Updating the MK3, values will reappear after the update is complete"
					Global.showToastNotification(VenusOS.Notification_Info, qsTrId("vebus_device_updating_the_mk3"), 10000)
					mk3firmware.doUpdate()
				}
			}

			/*	This shows the current limits for Ac/In/<x>/CurrentLimit.
				Note that gui-v1 instead shows a single current limit based on Ac/ActiveIn/CurrentLimit, which is deprecated in the dbus doco. */
			Column {
				width: parent ? parent.width : 0

				Repeater {
					model: AcInputSettingsModel {
						serviceUid: root.veBusDevice.serviceUid
					}
					delegate: ListItem {
						id: currentLimitListButton
						writeAccessLevel: VenusOS.User_AccessType_User
						text: Global.acInputs.currentLimitTypeToText(modelData.inputType)
						content.children: [
							CurrentLimitButton {
								width: Math.min(implicitWidth, currentLimitListButton.maximumContentWidth)
								serviceUid: root.veBusDevice.serviceUid
								inputNumber: modelData.inputNumber
								inputType: modelData.inputType
							}
						]
					}
				}
			}

			ListTextItem {
				//% "Charging the battery to 100%"
				text: qsTrId("vebus_device_charging_to_100")
				//% "In progress"
				secondaryText: qsTrId("vebus_device_in_progress")
				allowed: preferRenewableEnergy.value === 2
			}

			ListNavigationItem {
				text: chargeInProcess ?
						  //% "Press to stop"
						  qsTrId("vebus_device_press_to_stop")
						:
						  //% "Press to start"
						  qsTrId("vebus_device_press_to_start")
				secondaryText: chargeInProcess ?
								   //% "Charging the battery to 100%"
								   qsTrId("vebus_device_charging_the_battery_to_100")
								 :
								   //% "Charge the battery to 100%"
								   qsTrId("vebus_device_charge_the_battery_to_100")
				allowed: preferRenewableEnergy.isValid && preferRenewableEnergy.value !== 2
				onClicked: Global.pageManager.pushPage(newPageComponent)

				Component {
					id: newPageComponent

					Page {
						//% "The system will return to normal operation, prioritizing renewable energy.\nDo you want to continue?"
						readonly property string returnToNormal: qsTrId("vebus_device_return_to_normal_operation")

						GradientListView {

							Timer {
								id: popTimer

								interval: Theme.animation_settings_radioButtonPage_autoClose_duration
								onTriggered: Global.pageManager.popPage()
							}

							model: ObjectModel {
								ListItem {
									text: {
										var message = ""
										if (firmwareVersion.value < 0x506) { // Partial support S&W support
											message = !chargeInProcess
													? //% "Shore power will be used when available and the \"Solar & wind priority\" option will be ignored.\nDo you want to continue?"
													  qsTrId("vebus_device_use_shore_power")
													: returnToNormal
										} else {
											message = !chargeInProcess
													? //% "Shore power will be used to complete a full battery charge for one time.\nAfter the charging process is complete, the system will return to normal operation, prioritizing solar and wind energy.\nDo you want to continue?"
													  qsTrId("ebus_device_use_shore_power_once")
													: returnToNormal
										}
										return message
									}
								}

								ListButton {
									secondaryText: CommonWords.yes
									onClicked: {
										preferRenewableEnergy.setValue(chargeInProcess ? 1 : 0)
										popTimer.restart()
									}
								}

								ListButton {
									secondaryText: CommonWords.no
									onClicked: popTimer.restart()
								}
							}
						}
					}
				}
			}

			ListQuantityItem {
				dataItem.uid: veBusDevice.serviceUid + "/Dc/0/Voltage"
				//% "DC Voltage"
				text: qsTrId("vebus_device_page_dc_voltage")
				unit: VenusOS.Units_Volt_DC
			}

			ListQuantityItem {
				dataItem.uid: veBusDevice.serviceUid + "/Dc/0/Current"
				//% "DC Current"
				text: qsTrId("vebus_device_page_dc_current")
				unit: VenusOS.Units_Amp
			}

			ListQuantityItem {
				dataItem.uid: veBusDevice.serviceUid + "/Soc"
				text: CommonWords.state_of_charge
				unit:VenusOS.Units_Percentage
			}

			ListTemperatureItem {
				allowed: defaultAllowed && dataItem.isValid && root.isMulti
				dataItem.uid: veBusDevice.serviceUid + "/Dc/0/Temperature"
				text: CommonWords.battery_temperature
			}

			ActiveAcInputTextItem {
				bindPrefix: root.veBusDevice.serviceUid
			}

			VeBusAcIODisplay {
				serviceUid: root.veBusDevice.serviceUid
			}

			ListNavigationItem {
				//% "Advanced"
				text: qsTrId("vebus_device_page_advanced")
				onClicked: Global.pageManager.pushPage("/pages/vebusdevice/PageVeBusAdvanced.qml",
													   { "veBusDevice": root.veBusDevice,
														   "title": text
													   })
			}

			ListNavigationItem {
				text: CommonWords.alarm_status
				onClicked: Global.pageManager.pushPage("/pages/vebusdevice/PageVeBusAlarms.qml",
													   {
														   "bindPrefix": root.veBusDevice.serviceUid,
														   "veBusDevice": root.veBusDevice,
														   "isMulti": root.isMulti
													   })
			}

			ListNavigationItem {
				text: CommonWords.alarm_setup
				onClicked: Global.pageManager.pushPage("/pages/vebusdevice/PageVeBusAlarmSettings.qml",
													   {
														   "title": text,
														   "isMulti": root.isMulti
													   })

			}

			ListLabel {
				//% "A VE.Bus BMS automatically turns the system off when needed to protect the battery. Controlling the system from the Color Control is therefore not possible."
				text: qsTrId("vebus_device_bms_message")
				allowed: bmsMode.isValid
			}

			ListLabel {
				//% "A BMS assistant is installed configured for a VE.Bus BMS, but the VE.Bus BMS is not found!"
				text: qsTrId("vebus_device_bms_not_found")
				allowed: bmsType.value === VenusOS.VeBusDevice_Bms_Type_VeBus && !bmsMode.isValid
			}

			ListNavigationItem {
				//% "VE.Bus BMS"
				text: qsTrId("vebus_device_vebus_bms")
				allowed: bmsExpected.value === 1
				onClicked: Global.pageManager.pushPage("/pages/vebusdevice/PageVeBusBms.qml", {
														   "title": text,
														   "bindPrefix": root.veBusDevice.serviceUid
													   })
			}

			ListNavigationItem {
				text: CommonWords.ac_sensors
				showAccessLevel: VenusOS.User_AccessType_Service
				onClicked: Global.pageManager.pushPage("/pages/vebusdevice/PageAcSensors.qml", {
														   "title": text,
														   "bindPrefix": root.veBusDevice.serviceUid + "/AcSensor"
													   }
													   )
			}

			ListNavigationItem {
				text: CommonWords.debug
				showAccessLevel: VenusOS.User_AccessType_Service
				onClicked: Global.pageManager.pushPage("/pages/vebusdevice/PageVeBusDebug.qml", {
														   "title": text,
														   "bindPrefix": root.veBusDevice.serviceUid
													   }
													   )
			}

			ListNavigationItem {
				text: CommonWords.device_info_title
				onClicked: Global.pageManager.pushPage("/pages/vebusdevice/PageVeBusDeviceInfo.qml", {
														   "title": text,
														   "bindPrefix": root.veBusDevice.serviceUid
													   }
													   )
			}
		}
	}
}
