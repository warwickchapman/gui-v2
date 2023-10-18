/*
** Copyright (C) 2021 Victron Energy B.V.
*/

import QtQuick
import QtQuick.Window
import Victron.VenusOS

Page {
	id: root

	property int cardWidth: cardsView.count > 2
			? Theme.geometry.controlCard.minimumWidth
			: Theme.geometry.controlCard.maximumWidth

	topLeftButton: VenusOS.StatusBar_LeftButton_ControlsActive

	ListView {
		id: cardsView

		anchors {
			left: parent.left
			leftMargin: Theme.geometry.controlCardsPage.horizontalMargin
			right: parent.right
			top: parent.top
			bottom: parent.bottom
			bottomMargin: Theme.geometry.controlCardsPage.bottomMargin
		}
		rightMargin: Theme.geometry.controlCardsPage.horizontalMargin
		spacing: Theme.geometry.controlCardsPage.spacing
		orientation: ListView.Horizontal
		snapMode: ListView.SnapOneItem
		boundsBehavior: Flickable.DragOverBounds

		model: ObjectModel {
			Row {
				height: cardsView.height

				Repeater {
					model: Global.generators.model

					GeneratorCard {
						width: root.cardWidth
						generator: model.device
					}
				}
			}

			Row {
				height: cardsView.height

				Repeater {
					model: Global.veBusDevices.model

					VeBusDeviceCard {
						width: root.cardWidth
						veBusDevice: model.device
					}
				}
			}

			ESSCard {
				width: root.cardWidth
			}

			SwitchesCard {
				width: visible ? root.cardWidth : 0
				model: Global.relays.manualRelays
				visible: model.count > 0
			}
		}
	}
}
