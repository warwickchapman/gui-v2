/*
** Copyright (C) 2024 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

import QtQuick
import Victron.VenusOS
import QZXing
import QtQuick.Templates as T

Page {
	id: root

    readonly property string firmwareInstalledBuild: firmwareInstalledBuildItem.isValid ? firmwareInstalledBuildItem.value : ""
	readonly property string firmwareInstalledVersion: firmwareInstalledVersionItem.isValid ? firmwareInstalledVersionItem.value : ""
    readonly property string firmwareOnlineAvailableBuild: firmwareOnlineAvailableBuildItem.isValid ? firmwareOnlineAvailableBuildItem.value : ""
    readonly property string firmwareOnlineAvailableVersion: firmwareOnlineAvailableVersionItem.isValid ? firmwareOnlineAvailableVersionItem.value : ""
    readonly property bool firmwareOnlineCheck: firmwareOnlineCheckItem.isValid ? firmwareOnlineCheckItem.value : false
    readonly property int firmwareState: firmwareStateItem.isValid ? firmwareStateItem.value : FirmwareUpdater.Idle
    // readonly property int fsModifiedCheck: fsModifiedCheckItem.isValid ? fsModifiedCheckItem.value : 0
    readonly property int fsModifiedStatus: fsModifiedStatusItem.isValid ? fsModifiedStatusItem.value : 0

	function getFsModifiedState() {
		if (fsModifiedStatus === 0) {
			//% "Clean"
			// return qsTrId("settings_support_and_troubleshoot_clean")
            return "Clean"
		} else if (fsModifiedStatus === 1) {
            //% "Modified"
            // return qsTrId("settings_support_and_troubleshoot_modified")
            return "Modified"
		} else {
            //% "Unknown"
            // return qsTrId("settings_support_and_troubleshoot_unknown")
            return "Unknown"
        }
	}

    VeQuickItem {
        id: troubleshootEnabledItem
        uid: Global.systemSettings.serviceUid + "/Settings/System/Troubleshoot/Enabled"
    }
	VeQuickItem {
		id: firmwareInstalledBuildItem
		uid: Global.venusPlatform.serviceUid + "/Firmware/Installed/Build"
	}
	VeQuickItem {
		id: firmwareInstalledVersionItem
		uid: Global.venusPlatform.serviceUid + "/Firmware/Installed/Version"
	}
    VeQuickItem {
        id: firmwareOnlineAvailableBuildItem
        uid: Global.venusPlatform.serviceUid + "/Firmware/Online/AvailableVersion"
    }
    VeQuickItem {
        id: firmwareOnlineAvailableVersionItem
        uid: Global.venusPlatform.serviceUid + "/Firmware/Online/AvailableBuild"
    }
    VeQuickItem {
        id: firmwareOnlineCheckItem
        uid: Global.venusPlatform.serviceUid + "/Firmware/Online/Check"
    }
    VeQuickItem {
        id: firmwareStateItem
        uid: Global.venusPlatform.serviceUid + "/Firmware/State"
    }
    VeQuickItem {
        id: forceFirmwareReinstallItem
        uid: Global.venusPlatform.serviceUid + "/Troubleshoot/ForceFirmwareReinstall"
    }
    VeQuickItem {
        id: fsModifiedCheckItem
        uid: Global.venusPlatform.serviceUid + "/Troubleshoot/FsModified/Check"
    }
    VeQuickItem {
        id: fsModifiedStatusItem
        uid: Global.venusPlatform.serviceUid + "/Troubleshoot/FsModified/Status"
    }


	GradientListView {
		id: settingsListView

		model: ObjectModel {

			ListSwitch {
                id: troubleshootEnabled
				text: "Disable all third party integrations"
                /*
                Venus Platform
                - Save the current state of Signal K and Node-RED
                - Disable and lock Signal K
                - Disable and lock Node-RED
                - Disable rc.local by renaming it to rc.local.disabled
                - Disable rcS.local by renaming it to rcS.local.disabled
                */
				dataItem.uid: Global.systemSettings.serviceUid + "/Settings/System/Troubleshoot/Enabled"
			}

			ListTextItem {
				text: "Root FS status"
				secondaryText: getFsModifiedState()
			}

			ListButton {
				id: installUpdate

				text: "Is Venus OS on the latest version?"
				button.text: {
                    if (firmwareOnlineAvailableBuild == "" && firmwareOnlineAvailableVersion == "") {
                        return "Yes"
                    } else if (Global.firmwareUpdate.checkingForUpdate) {
                        return "Checking..."
                    } else if (firmwareState == FirmwareUpdater.ErrorDuringChecking) {
                        return "Online check failed"
                    } else if  (Global.firmwareUpdate.state === FirmwareUpdater.DownloadingAndInstalling) {
						if (progress.value) {
							//: Firmware update progress. %1 = firmware version, %2 = current update progress
							//% "Installing %1 %2%"
							return qsTrId("settings_firmware_online_installing_progress").arg(Global.firmwareUpdate.onlineAvailableVersion).arg(progress.value)
						}
						//: %1 = firmware version
						//% "Installing %1..."
						return qsTrId("settings_firmware_online_installing").arg(Global.firmwareUpdate.onlineAvailableVersion)
					} else {
						//: %1 = firmware version
						//% "Press to update to %1"
						return qsTrId("settings_firmware_online_press_to_update_to").arg(Global.firmwareUpdate.onlineAvailableVersion)
					}
				}

				enabled: !Global.firmwareUpdate.busy && !!Global.firmwareUpdate.onlineAvailableVersion && !Global.firmwareUpdate.checkingForUpdate
				writeAccessLevel: VenusOS.User_AccessType_User
				onClicked: {
					Global.firmwareUpdate.installUpdate(VenusOS.Firmware_UpdateType_Online)
				}

				VeQuickItem {
					id: progress
					uid: Global.venusPlatform.serviceUid + "/Firmware/Progress"
				}
			}

			ListButton {
				text: "Force clean online Venus OS update"
				//% "Reboot now"
				button.text: "Press to start"
				writeAccessLevel: VenusOS.User_AccessType_User
				onClicked: Global.dialogLayer.open(confirmReinstallDialogComponent)

				Component {
					id: confirmReinstallDialogComponent

					ModalWarningDialog {
						//% "Press 'OK' to reinstall root fs and reboot."
						title: "Press 'OK' to force an online Venus OS update.<br>Before the update third party integrations will be disabled and they can be enabled again later."
						dialogDoneOptions: VenusOS.ModalDialog_DoneOptions_OkAndCancel
						onClosed: {
							if (result === T.Dialog.Accepted) {
								troubleshootEnabledItem.setValue(1)
                                forceFirmwareReinstallItem.setValue(1)
							}
						}
					}
				}

			}

            /*
			ListNavigationItem {
				//% "Online updates"
				text: qsTrId("settings_online_updates")
				onClicked: {
					Global.pageManager.pushPage("/pages/settings/PageSettingsFirmwareOnline.qml", { title: text })
				}
			}

			ListNavigationItem {
				//% "Install firmware from SD/USB"
				text: qsTrId("settings_install_firmware_from_sd_usb")
				onClicked: {
					Global.pageManager.pushPage("/pages/settings/PageSettingsFirmwareOffline.qml", { title: text })
				}
			}
            */

			ListButton {
				text: "Check the FAQ"
				button.text: "Open in a new tab"
                allowed: defaultAllowed && Qt.platform.os === "wasm"
				onClicked: BackendConnection.openUrl("https://www.victronenergy.com/media/pg/Energy_Storage_System/en/faq.html")
			}

			ListItem {
				text: "Check the FAQ"
                // allowed: defaultAllowed && Qt.platform.os !== "wasm"
				content.children: [
					Image {
						source: "image://QZXing/encode/" + "https://www.victronenergy.com/media/pg/Energy_Storage_System/en/faq.html" +
								"?correctionLevel=M" +
								"&format=qrcode"
						sourceSize.width: 200
						sourceSize.height: 200

                        width: 200
                        height: 200
					}
				]
			}

			ListButton {
				text: "Check how to troubleshoot"
				button.text: "Open in a new tab"
                allowed: defaultAllowed && Qt.platform.os === "wasm"
				onClicked: BackendConnection.openUrl("https://www.victronenergy.com/media/pg/Venus_GX/en/troubleshooting.html")
			}

            ListItem {
                text: "Check how to troubleshoot"
                // allowed: defaultAllowed && Qt.platform.os !== "wasm"
                content.children: [
                    Image {
                        source: "image://QZXing/encode/" + "https://www.victronenergy.com/media/pg/Venus_GX/en/troubleshooting.html" +
                                "?correctionLevel=S" +
                                "&format=qrcode"
                        sourceSize.width: 200
                        sourceSize.height: 200

                        width: 200
                        height: 200

                        anchors.topMargin: 10
                        anchors.bottomMargin: 10
                    }
                ]
            }

            ListButton {
                text: "Check the forum"
                button.text: "Open in a new tab"
                allowed: defaultAllowed && Qt.platform.os === "wasm"
                onClicked: BackendConnection.openUrl("https://community.victronenergy.com/")
            }

            ListItem {
                text: "Check the forum"
                // allowed: defaultAllowed && Qt.platform.os !== "wasm"
                content.children: [
                    Image {
                        source: "image://QZXing/encode/" + "https://community.victronenergy.com/" +
                                "?correctionLevel=M" +
                                "&format=qrcode"
                        sourceSize.width: 200
                        sourceSize.height: 200

                        width: 200
                        height: 200
                    }
                ]
            }

            ListButton {
                text: "Find a local distributor"
                button.text: "Open in a new tab"
                allowed: defaultAllowed && Qt.platform.os === "wasm"
                onClicked: BackendConnection.openUrl("https://www.victronenergy.com/where-to-buy")
            }

            ListItem {
                text: "Find a local distributor"
                // allowed: defaultAllowed && Qt.platform.os !== "wasm"
                content.children: [
                    Image {
                        source: "image://QZXing/encode/" + "https://www.victronenergy.com/where-to-buy" +
                                "?correctionLevel=M" +
                                "&format=qrcode"
                        sourceSize.width: 200
                        sourceSize.height: 200

                        width: 200
                        height: 200
                    }
                ]
            }
		}
	}


    Component.onCompleted: {
        // Check for updates
        if (firmwareOnlineCheck === false) {
            Global.firmwareUpdate.checkForUpdate(VenusOS.Firmware_UpdateType_Online)
        }

        // Start checking for root fs status
        fsModifiedCheckItem.setValue(1)

    }

}
