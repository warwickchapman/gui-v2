/*
** Copyright (C) 2021 Victron Energy B.V.
*/

import QtQuick
import QtQuick.Window
import QtQuick.Controls.impl as CP
import Victron.VenusOS

Item {
	id: gauges

	property alias model: arcRepeater.model
	readonly property real strokeWidth: Theme.geometry.circularMultiGauge.strokeWidth

	// Step change in the size of the bounding boxes of successive gauges
	readonly property real _stepSize: 2 * (strokeWidth + Theme.geometry.circularMultiGauge.spacing)

	Item {
		id: arcGauges
		readonly property int antialiasingFactor: 2
		width: parent.width*antialiasingFactor
		height: parent.height*antialiasingFactor
		visible: false

		Repeater {
			id: arcRepeater
			width: parent.width
			model: gauges.model
			delegate: ProgressArc {
				property int status: Gauges.getValueStatus(model.value, model.valueType)
				width: parent.width - (strokeWidth + index*_stepSize*arcGauges.antialiasingFactor)
				height: width
				anchors.centerIn: parent
				radius: width/2
				startAngle: 0
				endAngle: 270
				value: model.value
				progressColor: Theme.statusColorValue(status)
				remainderColor: Theme.statusColorValue(status, true)
				strokeWidth: gauges.strokeWidth * arcGauges.antialiasingFactor
				visible: model.index < Theme.geometry.briefPage.centerGauge.maximumGaugeCount
			}
		}
	}
	ShaderEffectSource {
		id: antialiasedArcGauges
		anchors.fill: parent
		sourceItem: arcGauges
		smooth: true
	}

	Item {
		id: textCol

		anchors.top: parent.top
		anchors.topMargin: strokeWidth/2
		anchors.bottom: parent.verticalCenter
		anchors.left: parent.left
		anchors.right: parent.horizontalCenter
		anchors.rightMargin: Theme.geometry.circularMultiGauge.labels.rightMargin

		Repeater {
			width: parent.width
			model: gauges.model
			delegate: Row {
				anchors.verticalCenter: textCol.top
				anchors.verticalCenterOffset: index * _stepSize/2
				anchors.right: parent.right
				anchors.rightMargin: Math.max(0, Theme.geometry.circularMultiGauge.icons.maxWidth - iconImage.width)
				spacing: Theme.geometry.circularMultiGauge.row.spacing
				visible: model.index < Theme.geometry.briefPage.centerGauge.maximumGaugeCount

				Label {
					horizontalAlignment: Text.AlignRight
					font.pixelSize: Theme.font.size.m
					color: Theme.color.font.primary
					text: model.name
				}
				Label {
					anchors.verticalCenter: parent.verticalCenter
					horizontalAlignment: Text.AlignRight
					font.pixelSize: Theme.font.size.m
					color: Theme.color.font.primary
					visible: Preferences.showPercentagesInBriefPage
					//% "%1%"
					text: qsTrId("%1%").arg(model.value)
				}
				CP.ColorImage {
					id: iconImage
					anchors.verticalCenter: parent.verticalCenter
					height: Theme.geometry.briefPage.centerGauge.icon.height
					source: model.icon
					color: Theme.color.font.primary
					fillMode: Image.PreserveAspectFit
					smooth: true
				}
			}
		}
	}
}
