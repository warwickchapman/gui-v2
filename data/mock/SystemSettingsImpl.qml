/*
** Copyright (C) 2022 Victron Energy B.V.
*/

import QtQuick
import Victron.VenusOS

QtObject {
	id: root

	function setMockSettingValue(settingId, value) {
		Global.demoManager.mockDataValues["com.victronenergy.settings/Settings/" + settingId] = value
	}

	function setMockSystemValue(key, value) {
		Global.demoManager.mockDataValues["com.victronenergy.system/" + key] = value
	}

	Component.onCompleted: {
		// Settings that are converted for convenient UI access
		Global.systemSettings.accessLevel.setValue(VenusOS.User_AccessType_Service)
		Global.systemSettings.demoMode.setValue(VenusOS.SystemSettings_DemoModeActive)
		Global.systemSettings.colorScheme.setValue(Theme.Dark)
		Global.systemSettings.energyUnit.setValue(VenusOS.Units_Energy_Watt)
		Global.systemSettings.temperatureUnit.setValue(VenusOS.Units_Temperature_Celsius)
		Global.systemSettings.volumeUnit.setValue(VenusOS.Units_Volume_CubicMeter)
		Global.systemSettings.briefView.showPercentages.setValue(false)

		// Other system settings
		setMockSettingValue("System/VncInternet", 1)
		setMockSettingValue("System/VncLocal", 1)
		setMockSettingValue("SystemSetup/AcInput1", 2)
		setMockSettingValue("SystemSetup/AcInput2", 3)

		setMockSystemValue("AvailableBatteryServices", '{"default": "Automatic", "nobattery": "No battery monitor", "com.victronenergy.vebus/257": "Quattro 24/3000/70-2x50 on VE.Bus", "com.victronenergy.battery/0": "Lynx Smart BMS 500 on VE.Can"}')
		setMockSystemValue("AutoSelectedBatteryService", "Lynx Smart BMS 500 on VE.Can")
		setMockSystemValue("AvailableBatteries", '{"com.victronenergy.battery/0": {"name": "Lynx Smart BMS HQ21302VUDQ", "channel": null, "type": "battery"}, "com.victronenergy.vebus/257": {"name": "Quattro 24/3000/70-2x50", "channel": null, "type": "vebus"}}')
		setMockSystemValue("ActiveBatteryService", "com.victronenergy.battery/0")
		setMockSettingValue("SystemSetup/Batteries/Configuration/com_victronenergy_battery/0/Enabled", 1)
		setMockSettingValue("SystemSetup/Batteries/Configuration/com_victronenergy_battery/0/Name", "My battery")
		setMockSettingValue("SystemSetup/Batteries/Configuration/com_victronenergy_vebus/257/Enabled", 1)
		setMockSettingValue("SystemSetup/Batteries/Configuration/com_victronenergy_vebus/257/Name", "")
		setMockSettingValue("SystemSetup/BatteryService", "default")
		setMockSettingValue("Alarm/System/GridLost", 1)

		setMockSettingValue("System/TimeZone", "Europe/Berlin")

		setMockSettingValue("Services/Bol", 1)
		setMockSettingValue("SystemSetup/MaxChargeCurrent", -1)
		setMockSettingValue("SystemSetup/MaxChargeVoltage", 0)
		setMockSettingValue("SystemSetup/SharedVoltageSense", 3)
		setMockSettingValue("SystemSetup/TemperatureService", "default")
		setMockSystemValue("AvailableTemperatureServices", '{"com.victronenergy.vebus/257/Dc/0/Temperature": "Quattro 24/3000/70-2x50 on VE.Bus","default": "Automatic","nosensor": "No sensor"}')
		setMockSystemValue("AutoSelectedTemperatureService", "-")
		setMockSettingValue("SystemSetup/SharedTemperatureSense", 2)
		setMockSystemValue("Control/BatteryCurrentSense", 0)

		setMockSystemValue("SystemType", "ESS")
		setMockSettingValue("CGwacs/AcPowerSetPoint", 50)
		setMockSettingValue("CGwacs/BatteryLife/DischargedTime", 0)
		setMockSettingValue("CGwacs/BatteryLife/Flags", 0)
		setMockSettingValue("CGwacs/BatteryLife/MinimumSocLimit", 10)
		setMockSettingValue("CGwacs/BatteryLife/Schedule/Charge/0/Day", -1)
		setMockSettingValue("CGwacs/BatteryLife/Schedule/Charge/0/Duration", -1)
		setMockSettingValue("CGwacs/BatteryLife/Schedule/Charge/0/Soc", 100)
		setMockSettingValue("CGwacs/BatteryLife/Schedule/Charge/0/Start", 0)
		setMockSettingValue("CGwacs/BatteryLife/SocLimit", 10)
		setMockSettingValue("CGwacs/BatteryLife/State", 4)
		setMockSettingValue("CGwacs/Hub4Mode", 2)
		setMockSettingValue("CGwacs/MaxChargePower", -1)
		setMockSettingValue("CGwacs/MaxDischargePower", -1)
		setMockSettingValue("CGwacs/RunWithoutGridMeter", 0)
		setMockSettingValue("CGwacs/PreventFeedback", 0)

		setMockSettingValue("CGwacs/DeviceIds", "1,2,3,4,5,6")
		setMockSettingValue("Devices/cgwacs_1/CustomName", "pvinverter customname1")
		setMockSettingValue("Devices/cgwacs_2/CustomName", "grid customname2")
		setMockSettingValue("Devices/cgwacs_3/CustomName", "genset customname3")
		setMockSettingValue("Devices/cgwacs_4/CustomName", "acload customname4")
		setMockSettingValue("Devices/cgwacs_5/CustomName", "pvinverter customname5")
		setMockSettingValue("Devices/cgwacs_6/CustomName", "grid customname6")
		setMockSettingValue("Devices/cgwacs_1/ServiceType", "pvinverter")
		setMockSettingValue("Devices/cgwacs_2/ServiceType", "grid")
		setMockSettingValue("Devices/cgwacs_3/ServiceType", "genset")
		setMockSettingValue("Devices/cgwacs_4/ServiceType", "acload")
		setMockSettingValue("Devices/cgwacs_5/ServiceType", "pvinverter")
		setMockSettingValue("Devices/cgwacs_6/ServiceType", "grid")
		setMockSettingValue("Devices/cgwacs_1/L2/ServiceType", "pvinverter")
		setMockSettingValue("Devices/cgwacs_2/L2/ServiceType", "grid")
		setMockSettingValue("Devices/cgwacs_3/L2/ServiceType", "genset")
		setMockSettingValue("Devices/cgwacs_4/L2/ServiceType", "acload")
		setMockSettingValue("Devices/cgwacs_1/ClassAndVrmInstance", "pvinverter:1")
		setMockSettingValue("Devices/cgwacs_2/ClassAndVrmInstance", "grid:1")
		setMockSettingValue("Devices/cgwacs_3/ClassAndVrmInstance", "genset:1")
		setMockSettingValue("Devices/cgwacs_4/ClassAndVrmInstance", "acload:1")
		setMockSettingValue("Devices/cgwacs_1/Position", 0)
		setMockSettingValue("Devices/cgwacs_2/Position", 1)
		setMockSettingValue("Devices/cgwacs_3/Position", 2)
		setMockSettingValue("Devices/cgwacs_4/Position", 0)
		setMockSettingValue("Devices/cgwacs_5/Position", 1)
		setMockSettingValue("Devices/cgwacs_6/Position", 2)
		setMockSettingValue("Devices/cgwacs_1/SupportMultiphase", 1)
		setMockSettingValue("Devices/cgwacs_2/SupportMultiphase", 1)
		setMockSettingValue("Devices/cgwacs_3/SupportMultiphase", 0)
		setMockSettingValue("Devices/cgwacs_4/SupportMultiphase", 1)
		setMockSettingValue("Devices/cgwacs_5/SupportMultiphase", 0)
		setMockSettingValue("Devices/cgwacs_6/SupportMultiphase", 1)
		setMockSettingValue("Devices/cgwacs_1/IsMultiphase", 1)
		setMockSettingValue("Devices/cgwacs_2/IsMultiphase", 0)
		setMockSettingValue("Devices/cgwacs_3/IsMultiphase", 1)
		setMockSettingValue("Devices/cgwacs_4/IsMultiphase", 0)
		setMockSettingValue("Devices/cgwacs_5/IsMultiphase", 1)
		setMockSettingValue("Devices/cgwacs_6/IsMultiphase", 0)
		setMockSettingValue("Devices/cgwacs_1_S/Enabled", 0)
		setMockSettingValue("Devices/cgwacs_2_S/Enabled", 1)
		setMockSettingValue("Devices/cgwacs_3_S/Enabled", 0)
		setMockSettingValue("Devices/cgwacs_4_S/Enabled", 1)
		setMockSettingValue("Devices/cgwacs_5_S/Enabled", 0)
		setMockSettingValue("Devices/cgwacs_6_S/Enabled", 1)
		setMockSettingValue("Devices/cgwacs_1_S/Position", 0)
		setMockSettingValue("Devices/cgwacs_2_S/Position", 1)
		setMockSettingValue("Devices/cgwacs_3_S/Position", 2)
		setMockSettingValue("Devices/cgwacs_4_S/Position", 0)
		setMockSettingValue("Devices/cgwacs_5_S/Position", 1)
		setMockSettingValue("Devices/cgwacs_6_S/Position", 2)
	}

	property Connections briefSettingsConn: Connections {
		target: Global.systemSettings.briefView

		function onSetGaugeRequested(index, value) {
			Global.systemSettings.briefView.setGauge(index, value)
		}
	}
}
