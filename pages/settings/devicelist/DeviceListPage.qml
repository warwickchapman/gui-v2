/*
** Copyright (C) 2021 Victron Energy B.V.
*
* These settings are regularly brought up to date with the settings from gui-v1.
* Currently up to date with gui-v1 v5.6.6.
*/

import QtQuick
import Victron.VenusOS

Page {
	id: root

	Timer {
		running: true
		interval: 200
		onTriggered: {
			Global.pageManager.pushPage("/pages/settings/devicelist/battery/PageBattery.qml",
										{"battery": Global.batteries.model.objectAt(0)})
		}
	}

	// put in Global??
	readonly property var _allModels: [
		Global.acInputs.model,
		Global.batteries.model,
		Global.dcInputs.model,
		Global.digitalInputs.model,
		Global.environmentInputs.model,
		Global.evChargers.model,
//        Global.generators.model,
		Global.inverters.model,
		Global.pvInverters.model,
		Global.relays.model,
		Global.solarChargers.model
	]

	function _serviceTypeFromUid(serviceUid) {
		//xxx put this in the model as model.serviceType??
		if (BackendConnection.type === BackendConnection.MqttSource) {
			const mqttPrefix = "mqtt/"
			const remaining = serviceUid.substring(mqttPrefix.length)
			return remaining.substring(0, remaining.indexOf('/'))
		}
		const dbusPrefix = "com.victronenergy."
		const remaining = serviceUid.substring(dbusPrefix.length)
		return remaining.substring(0, remaining.indexOf('.'))
	}

	// xxxx this will just become a GradientListView containing the merged model
	Flickable {
		anchors.fill: parent
		contentHeight: contentColumn.height

		Column {
			id: contentColumn

			x: Theme.geometry.page.content.horizontalMargin
			width: parent.width - Theme.geometry.page.content.horizontalMargin

			Repeater {
				model: root._allModels

				Column {
					width: parent.width

					Repeater {
						model: modelData

						delegate: ListNavigationItem {
							text: modelData.name

							onClicked: {
//                                const serviceType = root._serviceTypeFromUid(modelData.serviceUid).trim()
//                                console.log("serviceType", modelData.serviceUid, serviceType, "::")

//                                if (serviceType === "vebus") {
//                                    Global.pageManager.pushPage("/pages/settings/devicelist/battery/PageVebus.qml", {"vebus": modelData})
//                                } else if (serviceType === "battery") {
//                                    console.log("..........show battery", modelData)
									Global.pageManager.pushPage("/pages/settings/devicelist/battery/PageBattery.qml", {"battery": modelData})
//                                } else if (serviceType === "solarcharger") {
//                                    Global.pageManager.pushPage("/pages/solar/SolarChargerPage.qml", {"solarCharger": modelData})
//                                }
							}
						}
					}
				}
			}

			SeparatorBar {
				width: parent.width
			}

			Repeater {
				model: Global.tanks.allTankModels

				Column {
					width: parent.width

					Repeater {
						model: modelData

						delegate: ListNavigationItem {
							text: modelData.name
						}
					}
				}
			}
		}
	}
}
