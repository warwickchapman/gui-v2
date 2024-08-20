/*
** Copyright (C) 2023 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

import QtQuick
import QtQuick.Controls.impl as CP
import Victron.VenusOS

Item {
	id: root

	property Generator generator
	property alias fontSize: label.font.pixelSize

	implicitHeight: label.height
	implicitWidth: label.x + label.width

	CP.IconImage {
		id: icon

		anchors.top: label.top
		width: Theme.geometry_generatorIconLabel_icon_width
		height: Theme.geometry_generatorIconLabel_icon_width
		color: Theme.color_font_primary
		source: {
			if (!root.generator || root.generator.state === VenusOS.Generators_RunningBy_NotRunning) {
				return ""
			}
			if (root.generator.runningBy === VenusOS.Generators_RunningBy_Manual) {
				if (root.generator.manualStartTimer > 0) {
					return "qrc:/images/icon_manualstart_timer_24.svg"
				} else {
					return "qrc:/images/icon_manualstart_24.svg"
				}
			}
			return "qrc:/images/icon_autostart_24.svg"
		}
	}

	GeneratorRuntimeLabel {
		id: label

		anchors {
			left: icon.right
			leftMargin: Theme.geometry_generatorIconLabel_icon_margin
		}
		serviceUid: root.generator.serviceUid
	}
}
