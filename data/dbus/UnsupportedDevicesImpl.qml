/*
** Copyright (C) 2023 Victron Energy B.V.
*/

import QtQuick
import Victron.VenusOS
import Victron.Veutil
import "../common"

QtObject {
	id: root

	property Instantiator objects: Instantiator {
		model: VeQItemSortTableModel {
			dynamicSortFilter: true
			filterRole: VeQItemTableModel.UniqueIdRole
			filterRegExp: "^dbus/com\.victronenergy\.unsupported\."
			model: Global.dataServiceModel
		}
		delegate: UnsupportedDevice {
			serviceUid: model.uid
		}
	}
}
