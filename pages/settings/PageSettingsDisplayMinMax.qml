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
			ListSwitch {
				//: Whether to adjust the min/max values in the range dynamically, based on the lowest and highest values observed on the system.
				//% "Auto-ranging"
				text: qsTrId("settings_minmax_autorange")
				dataItem.uid: Global.systemSettings.serviceUid + "/Settings/Gui/Gauges/AutoMax"
				bottomContentChildren: [
					ListLabel {
						topPadding: 0
						bottomPadding: 0
						color: Theme.color_font_secondary
						//% "When enabled, the minima and maxima of gauges and graphs are automatically adjusted based on past values."
						text: qsTrId("settings_minmax_autorange_desc")
					}
				]
			}

			ListButton {
				//% "Reset all range values to zero"
				text: qsTrId("settings_minmax_reset")
				secondaryText: CommonWords.reset
				onClicked: Global.dialogLayer.open(confirmResetDialog)

				Component {
					id: confirmResetDialog

					ModalWarningDialog {
						dialogDoneOptions: VenusOS.ModalDialog_DoneOptions_OkAndCancel
						//% "Reset Range Values"
						title: qsTrId("settings_wifi_disable_ap")
						//% "Are you sure that you want to reset all the values to zero?"
						description: qsTrId("settings_minmax_reset_are_you_sure")

						onAccepted: {
							for (let i = 0; i < acInputsRepeater.count; ++i) {
								acInputsRepeater.itemAt(i).reset()
							}
							dcInMaxPower.dataItem.setValue(0)
							acIn1MaxOutCurrent.dataItem.setValue(0)
							acIn2MaxOutCurrent.dataItem.setValue(0)
							noAcInMaxOutCurrent.dataItem.setValue(0)
							dcOutMaxPower.dataItem.setValue(0)
							pvMaxPower.dataItem.setValue(0)
						}
					}
				}
			}

			Column {
				width: parent ? parent.width : 0

				Repeater {
					id: acInputsRepeater

					model: 2
					delegate: Column {
						required property int index
						function reset() {
							acInputMinCurrent.dataItem.setValue(0)
							acInputMaxCurrent.dataItem.setValue(0)
						}

						width: parent ? parent.width : 0

						ListSectionHeader {
							text: {
								const inputInfo = Global.acInputs["input" + (index + 1) + "Info"]
								if (inputInfo.source === VenusOS.AcInputs_InputSource_NotAvailable) {
									return CommonWords.acInput(index)
								}
								//: %1 = 'AC input 1' or 'AC input 2', %2 = name of connected input (e.g. Grid, Shore)
								//% "%1 (%2)"
								return qsTrId("settings_minmax_ac_in_header_with_source")
										.arg(CommonWords.acInput(index))
										.arg(Global.acInputs.sourceToText(inputInfo.source))
							}
						}

						ListQuantityField {
							id: acInputMinCurrent
							text: CommonWords.minimum_current
							dataItem.uid: Global.systemSettings.serviceUid + "/Settings/Gui/Gauges/Ac/In/%1/Current/Min".arg(index)
							unit: VenusOS.Units_Amp
						}
						ListQuantityField {
							id: acInputMaxCurrent
							text: CommonWords.maximum_current
							dataItem.uid: Global.systemSettings.serviceUid + "/Settings/Gui/Gauges/Ac/In/%1/Current/Max".arg(index)
							unit: VenusOS.Units_Amp
						}
					}
				}
			}

			ListSectionHeader {
				//% "DC input"
				text: qsTrId("settings_minmax_dc_input")
			}

			ListQuantityField {
				id: dcInMaxPower
				text: CommonWords.maximum_power
				dataItem.uid: Global.systemSettings.serviceUid + "/Settings/Gui/Gauges/Dc/Input/Power/Max"
				unit: VenusOS.Units_Watt
			}

			ListSectionHeader {
				//% "AC output"
				text: qsTrId("settings_minmax_acout_max_power")
			}

			ListQuantityField {
				id: acIn1MaxOutCurrent
				//% "Maximum current: AC in 1 connected"
				text: qsTrId("settings_minmax_acout_max_acin1")
				dataItem.uid: Global.systemSettings.serviceUid + "/Settings/Gui/Gauges/Ac/AcIn1/Consumption/Current/Max"
				unit: VenusOS.Units_Amp
			}

			ListQuantityField {
				id: acIn2MaxOutCurrent
				//% "Maximum current: AC in 2 connected"
				text: qsTrId("settings_minmax_acout_max_acin2")
				dataItem.uid: Global.systemSettings.serviceUid + "/Settings/Gui/Gauges/Ac/AcIn2/Consumption/Current/Max"
				unit: VenusOS.Units_Amp
			}

			ListQuantityField {
				id: noAcInMaxOutCurrent
				//% "Maximum current: no AC inputs"
				text: qsTrId("settings_minmax_acout_max")
				dataItem.uid: Global.systemSettings.serviceUid + "/Settings/Gui/Gauges/Ac/NoAcIn/Consumption/Current/Max"
				unit: VenusOS.Units_Amp
			}

			ListSectionHeader {
				//% "DC output"
				text: qsTrId("settings_minmax_dc_out")
			}

			ListQuantityField {
				id: dcOutMaxPower
				text: CommonWords.maximum_power
				dataItem.uid: Global.systemSettings.serviceUid + "/Settings/Gui/Gauges/Dc/System/Power/Max"
				unit: VenusOS.Units_Watt
			}

			ListSectionHeader {
				//% "Solar"
				text: qsTrId("settings_minmax_solar")
			}

			ListQuantityField {
				id: pvMaxPower
				text: CommonWords.maximum_power
				dataItem.uid: Global.systemSettings.serviceUid + "/Settings/Gui/Gauges/Pv/Power/Max"
				unit: VenusOS.Units_Watt
			}
		}
	}
}
