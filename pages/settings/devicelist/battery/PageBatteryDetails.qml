/*
** Copyright (C) 2023 Victron Energy B.V.
*/

import QtQuick
import Victron.VenusOS
import "/components/Units.js" as Units

Page {
	id: root

	property string bindPrefix
	property var batteryDetails

	GradientListView {
		model: ObjectModel {
			ListTextGroup {
				//% "Lowest cell voltage"
				text: qsTrId("batterydetails_lowest_cell_voltage")
				textModel: [ batteryDetails.minVoltageCellId.value || "", batteryDetails.minCellVoltage.value || "" ]
			}

			ListTextGroup {
				//% "Highest cell voltage"
				text: qsTrId("batterydetails_highest_cell_voltage")
				textModel: [ batteryDetails.maxVoltageCellId.value || "", batteryDetails.maxCellVoltage.value || "" ]
			}

			ListQuantityGroup {
				//% "Minimum cell temperature"
				text: qsTrId("batterydetails_minimum_cell_temperature")
				textModel: [
					{
						value: Global.systemSettings.convertTemperature(batteryDetails.minTemperatureCellId.value),
						unit: Global.systemSettings.temperatureUnit.value
					},
					{
						value: Global.systemSettings.convertTemperature(batteryDetails.minCellTemperature.value),
						unit: Global.systemSettings.temperatureUnit.value
					}
				]
			}

			ListTextGroup {
				//% "Maximum cell temperature"
				text: qsTrId("batterydetails_maximum_cell_temperature")
				textModel: [
					{
						value: Global.systemSettings.convertTemperature(batteryDetails.maxTemperatureCellId.value),
						unit: Global.systemSettings.temperatureUnit.value
					},
					{
						value: Global.systemSettings.convertTemperature(batteryDetails.maxCellTemperature.value),
						unit: Global.systemSettings.temperatureUnit.value
					}
				]
			}

			ListTextGroup {
				//% "Battery modules"
				text: qsTrId("batterydetails_modules")
				textModel: [
					//: %1 = number of battery modules that are online
					//% "%1 online"
					qsTrId("devicelist_batterydetails_modules_online").arg(batteryDetails.modulesOnline.value || "--"),
					//: %1 = number of battery modules that are offline
					//% "%1 offline"
					qsTrId("devicelist_batterydetails_modules_offline").arg(batteryDetails.modulesOffline.value || "--")
				]
			}

			ListTextGroup {
				//% "Number of modules blocking charge / discharge"
				text: qsTrId("batterydetails_number_of_modules_blocking_charge_discharge")
				textModel: [ batteryDetails.nrOfModulesBlockingCharge.value || "", batteryDetails.nrOfModulesBlockingDischarge.value || "" ]
			}

			ListTextGroup {
				//% "Installed / Available capacity"
				text: qsTrId("batterydetails_installed_available_capacity")
				textModel: [ batteryDetails.installedCapacity.value || "", root.bindPrefix + "/Capacity" ]
			}
		}
	}
}
