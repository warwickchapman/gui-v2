/*
** Copyright (C) 2024 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

import QtQuick
import Victron.VenusOS

Page {
	id: root

	GradientListView {
		model: ObjectModel {
			ListRadioButtonGroup {
				id: nodered

				text: qsTrId("settings_large_node_red")
				dataItem.uid: Global.venusPlatform.serviceUid + "/Services/NodeRed/Mode"
				allowed: dataItem.isValid
				optionModel: [
					{ display: CommonWords.disabled, value: VenusOS.NodeRed_Mode_Disabled },
					{ display: CommonWords.enabled, value: VenusOS.NodeRed_Mode_Enabled },
					//% "Enabled (safe mode)"
					{ display: qsTrId("settings_large_enabled_safe_mode"), value: VenusOS.NodeRed_Mode_EnabledWithSafeMode },
				]
			}

			ListButton {
				id: resetButton
				//% "Node-RED factory reset"
				text: qsTrId("page_settings_nodered_factory_reset")
				secondaryText: CommonWords.press_to_reset
				allowed: true
				onClicked: Global.dialogLayer.open(factoryResetConfirmationDialogComponent)

				VeQuickItem {
					id: nodeRedFactoryResetItem
					uid: Global.venusPlatform.serviceUid + "/Services/NodeRed/FactoryReset"
				}

				Component {
					id: factoryResetConfirmationDialogComponent

					ModalWarningDialog {
						title: qsTrId("page_settings_nodered_factory_reset")
						//% "Are you sure that you want to reset Node-RED to factory defaults? This will delete all of your flows."
						description: qsTrId("page_settings_nodered_factory_reset_confirmation")
						dialogDoneOptions: VenusOS.ModalDialog_DoneOptions_OkAndCancel
						onAccepted: nodeRedFactoryResetItem.setValue(1)
					}
				}
			}

			ListLabel {
				//% "Access Node-RED at https://venus.local:1881 and via VRM."
				text: qsTrId("settings_large_access_node_red")
				allowed: nodered.currentValue > 0
			}
		}
	}
}
