/*
** Copyright (C) 2023 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

import QtQuick
import QtQuick.Controls as C
import QtQuick.Controls.impl as CP
import Victron.VenusOS

GradientListView {
	id: root

	property alias ipAddresses: ipAddresses
	property var _removalDialog

	signal ipAddressUpdated(index : int, ipAddress : string)

	model: ipAddresses.value ? ipAddresses.value.split(',') : []

	delegate: ListIpAddressField {
		id: ipAddressDelegate

		property RemoveButton removalButton: RemoveButton {
			onClicked: {
				if (!root._removalDialog) {
					root._removalDialog = removalDialogComponent.createObject(root)
				}
				root._removalDialog.description = modelData
				root._removalDialog.open()
			}
		}

		text: CommonWords.ip_address + ' ' + (model.index + 1)
		secondaryText: modelData
		saveInput: function() { root.ipAddressUpdated(model.index, textField.text) }

		content.children: [
			defaultContent,
			removalButton
		]
	}

	VeQuickItem {
		id: ipAddresses
	}

	Component {
		id: removalDialogComponent

		ModalWarningDialog {
			//% "Remove IP address?"
			title: qsTrId("settings_fronius_remove_ip_address")
			dialogDoneOptions: VenusOS.ModalDialog_DoneOptions_OkAndCancel
			icon.color: Theme.color_orange
			acceptText: CommonWords.remove

			onAccepted: {
				const addresses = ipAddresses.value ? ipAddresses.value.split(',') : []
				for (let i = 0; i < addresses.length; ++i) {
					if (addresses[i] === description) {
						addresses.splice(i, 1)
						ipAddresses.setValue(addresses.join(','))
						break
					}
				}
			}
		}
	}
}
