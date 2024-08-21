/*
** Copyright (C) 2023 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

import QtQuick
import Victron.VenusOS

Page {
	id: root

	GradientListView {
		model: Global.allDevicesModel

		delegate: Loader {
			id: delegateLoader

			required property bool connected
			required property BaseDevice device
			required property BaseDeviceModel sourceModel
			required property string cachedDeviceName

			readonly property bool _loadCustomDelegate: connected && !!device

			// Only set width; height is sized to the loaded item, in case allowed=false and the
			// item should not be visible.
			width: parent ? parent.width : 0

			on_LoadCustomDelegateChanged: {
				let delegateUri
				if (_loadCustomDelegate) {
					const serviceType = BackendConnection.serviceTypeFromUid(device.serviceUid)
					if (!serviceType) {
						console.warn("DeviceList: cannot load delegate, cannot read service type from serviceUid:", device.serviceUid)
						return
					}
					setSource("delegates/DeviceListDelegate_%1.qml".arg(serviceType), {
						device: Qt.binding(function() { return delegateLoader.device }),
						sourceModel: Qt.binding(function() { return delegateLoader.sourceModel }),
					})
				} else {
					setSource("delegates/DisconnectedDeviceListDelegate.qml", {
						cachedDeviceName: Qt.binding(function() { return delegateLoader.cachedDeviceName }),
					})
				}
			}
		}

		footer: ListButton {
			//% "Remove disconnected devices"
			text: qsTrId("devicelist_remove_disconnected_devices")
			secondaryText: CommonWords.remove
			allowed: Global.allDevicesModel.disconnectedDeviceCount > 0
			onClicked: {
				Global.allDevicesModel.removeDisconnectedDevices()
			}
		}
	}
}
