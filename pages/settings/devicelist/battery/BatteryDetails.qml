/*
** Copyright (C) 2023 Victron Energy B.V.
*/

import QtQuick
import Victron.VenusOS

QtObject {
	id: root

	property string bindPrefix
	property bool anyItemValid: false

	function _updateValid(value) {
		if (value !== undefined) {
			anyItemValid = true
		}
	}

	property DataPoint modulesOnline: DataPoint {
		source: root.bindPrefix + "/System/NrOfModulesOnline"
		onValueChanged: root._updateValid(value)
	}
	property DataPoint modulesOffline: DataPoint {
		source: root.bindPrefix + "/System/NrOfModulesOffline"
		onValueChanged: root._updateValid(value)
	}
	property DataPoint nrOfModulesBlockingCharge: DataPoint {
		source: root.bindPrefix + "/System/NrOfModulesBlockingCharge"
		onValueChanged: root._updateValid(value)
	}
	property DataPoint nrOfModulesBlockingDischarge: DataPoint {
		source: root.bindPrefix + "/System/NrOfModulesBlockingDischarge"
		onValueChanged: root._updateValid(value)
	}
	property DataPoint nrOfModulesOnline: DataPoint {
		source: root.bindPrefix + "/System/NrOfModulesOnline"
		onValueChanged: root._updateValid(value)
	}
	property DataPoint nrOfModulesOffline: DataPoint {
		source: root.bindPrefix + "/System/NrOfModulesOffline"
		onValueChanged: root._updateValid(value)
	}
	property DataPoint minCellVoltage: DataPoint {
		source: root.bindPrefix + "/System/MinCellVoltage"
		onValueChanged: root._updateValid(value)
	}
	property DataPoint maxCellVoltage: DataPoint {
		source: root.bindPrefix + "/System/MaxCellVoltage"
		onValueChanged: root._updateValid(value)
	}
	property DataPoint minCellTemperature: DataPoint {
		source: root.bindPrefix + "/System/MinCellTemperature"
		onValueChanged: root._updateValid(value)
	}
	property DataPoint maxCellTemperature: DataPoint {
		source: root.bindPrefix + "/System/MaxCellTemperature"
		onValueChanged: root._updateValid(value)
	}
	property DataPoint minVoltageCellId: DataPoint {
		source: root.bindPrefix + "/System/MinVoltageCellId"
		onValueChanged: root._updateValid(value)
	}
	property DataPoint maxVoltageCellId: DataPoint {
		source: root.bindPrefix + "/System/MaxVoltageCellId"
		onValueChanged: root._updateValid(value)
	}
	property DataPoint minTemperatureCellId: DataPoint {
		source: root.bindPrefix + "/System/MinTemperatureCellId"
		onValueChanged: root._updateValid(value)
	}
	property DataPoint maxTemperatureCellId: DataPoint {
		source: root.bindPrefix + "/System/MaxTemperatureCellId"
		onValueChanged: root._updateValid(value)
	}
	property DataPoint installedCapacity: DataPoint {
		source: root.bindPrefix + "/InstalledCapacity"
		onValueChanged: root._updateValid(value)
	}
}
