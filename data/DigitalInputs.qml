/*
** Copyright (C) 2023 Victron Energy B.V.
*/

import QtQuick
import Victron.VenusOS
import "common"

QtObject {
	id: root

	property DeviceModel model: DeviceModel {
		objectProperty: "input"
	}

	function addInput(input) {
		model.addObject(input)
	}

	function removeInput(input) {
		model.removeObject(input.serviceUid)
	}

	function reset() {
		model.clear()
	}

	function inputTypeToText(type) {
		switch (type) {
		case VenusOS.DigitalInput_Type_Disabled:
			//: Digital Input is disabled
			//% "Disabled"
			return qsTrId("digitalinputs_type_disabled")
		case VenusOS.DigitalInput_Type_PulseMeter:
			//% "Pulse meter"
			return qsTrId("digitalinputs_type_pulsemeter")
		case VenusOS.DigitalInput_Type_DoorAlarm:
			//% "Door alarm"
			return qsTrId("digitalinputs_type_dooralarm")
		case VenusOS.DigitalInput_Type_BilgePump:
			//% "Bilge pump"
			return qsTrId("digitalinputs_type_bilgepump")
		case VenusOS.DigitalInput_Type_BilgeAlarm:
			//% "Bilge alarm"
			return qsTrId("digitalinputs_type_bilgealarm")
		case VenusOS.DigitalInput_Type_BurglarAlarm:
			//% "Burglar alarm"
			return qsTrId("digitalinputs_type_burglaralarm")
		case VenusOS.DigitalInput_Type_SmokeAlarm:
			//% "Smoke alarm"
			return qsTrId("digitalinputs_type_smokealarm")
		case VenusOS.DigitalInput_Type_FireAlarm:
			//% "Fire alarm"
			return qsTrId("digitalinputs_type_firealarm")
		case VenusOS.DigitalInput_Type_CO2Alarm:
			//% "CO2 alarm"
			return qsTrId("digitalinputs_type_co2alarm")
		case VenusOS.DigitalInput_Type_Generator:
			//% "Generator"
			return qsTrId("digitalinputs_type_generator")
		default:
			return ""
		}
	}

	function inputStatusToText(status) {
		switch (status) {
		case VenusOS.DigitalInput_Status_Low:
			//% "Low"
			return qsTrId("digitalinputs_status_low")
		case VenusOS.DigitalInput_Status_High:
			//% "High"
			return qsTrId("digitalinputs_status_high")
		case VenusOS.DigitalInput_Status_Off:
			return CommonWords.off
		case VenusOS.DigitalInput_Status_On:
			return CommonWords.on
		case VenusOS.DigitalInput_Status_No:
			return CommonWords.no
		case VenusOS.DigitalInput_Status_Yes:
			return CommonWords.yes
		case VenusOS.DigitalInput_Status_Open:
			//% "Open"
			return qsTrId("digitalinputs_status_open")
		case VenusOS.DigitalInput_Status_Closed:
			//% "Closed"
			return qsTrId("digitalinputs_status_closed")
		case VenusOS.DigitalInput_Status_OK:
			return CommonWords.ok
		case VenusOS.DigitalInput_Status_Alarm:
			//% "Alarm"
			return qsTrId("digitalinputs_status_alarm")
		case VenusOS.DigitalInput_Status_Running:
			//% "Running"
			return qsTrId("digitalinputs_status_running")
		case VenusOS.DigitalInput_Status_Stopped:
			return CommonWords.stopped
		default:
			return ""
		}
	}

	Component.onCompleted: Global.digitalInputs = root
}
