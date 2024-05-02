/*
** Copyright (C) 2023 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

import QtQuick
import Victron.VenusOS

Rectangle {
	id: root

	property alias title: header.text
	property real temperature: NaN
	property real humidity: NaN
	property bool animationEnabled: true

	property var temperatureGaugeGradient
	property var humidityGaugeGradient

	readonly property int _twoGauges: !isNaN(temperature) && !isNaN(humidity)
	readonly property int _gaugeWidth: _twoGauges
			? (width - (2 * Theme.geometry_levelsPage_panel_border_width)) / 2
			: Theme.geometry_levelsPage_environment_gauge_width

	border.color: Theme.color_levelsPage_panel_border_color
	border.width: Theme.geometry_levelsPage_panel_border_width
	color: Theme.color_levelsPage_environment_panel_background
	radius: Theme.geometry_levelsPage_panel_radius

	Behavior on height {
		enabled: root.animationEnabled
		NumberAnimation { duration: Theme.animation_page_idleResize_duration; easing.type: Easing.InOutQuad }
	}

	GaugeHeader {
		id: header
		color: Theme.color_levelsPage_panel_border_color
	}

	EnvironmentGauge {
		id: tempGauge

		x: humidityGaugeLoader.active ? 0 : parent.width/2 - width/2
		anchors {
			top: header.bottom
			bottom: parent.bottom
		}
		width: root._gaugeWidth
		animationEnabled: root.animationEnabled
		icon.source: "qrc:/images/icon_temp_32.svg"

		text: Global.systemSettings.temperatureUnitSuffix
		value: Math.round(root.temperature)
		unit: Global.systemSettings.temperatureUnit

		minimumValue: Global.systemSettings.convertFromCelsius(Theme.geometry_levelsPage_environment_temperatureGauge_minimumValue)
		maximumValue: Global.systemSettings.convertFromCelsius(Theme.geometry_levelsPage_environment_temperatureGauge_maximumValue)
		highlightedValue: Theme.geometry_levelsPage_environment_temperatureGauge_highlightedValue
		minimumValueColor: Theme.color_blue
		maximumValueColor: Theme.color_red
		highlightedValueColor: Theme.color_levelsPage_environment_temperatureGauge_highlightValue
		gradient: root.temperatureGaugeGradient
	}

	Loader {
		id: humidityGaugeLoader

		anchors {
			top: header.bottom
			right: parent.right
			bottom: parent.bottom
		}

		active: !isNaN(root.humidity)
		sourceComponent: EnvironmentGauge {
			id: humidityGauge

			width: root._gaugeWidth
			icon.source: "qrc:/images/icon_humidity_32.svg"
			// Don't translate. Short local acronyms often don't exist. RH is an international standard.
			// In case user is not familiar with the acronym "RH" there is also drop icon and percentage sign (%).
			text: "RH"
			animationEnabled: root.animationEnabled
			unit: VenusOS.Units_Percentage
			value: Math.round(root.humidity)
			minimumValue: Theme.geometry_levelsPage_environment_humidityGauge_minimumValue
			maximumValue: Theme.geometry_levelsPage_environment_humidityGauge_maximumValue
			highlightedValue: Theme.geometry_levelsPage_environment_humidityGauge_highlightedValue
			minimumValueColor: Theme.color_orange
			maximumValueColor: Theme.color_blue
			highlightedValueColor: Theme.color_green
			gradient: root.humidityGaugeGradient
		}
		onStatusChanged: if (status === Loader.Error) console.warn("Unable to load himidity environment gauge:", errorString())
	}
}
