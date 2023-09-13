/*
** Copyright (C) 2021 Victron Energy B.V.
*/

import QtQuick
import Victron.Veutil
import Victron.VenusOS

QtObject {
	id: root

	property Instantiator relayObjects: Instantiator {
		model: VeQItemTableModel {
			uids: ["mqtt/system/0/Relay"]
			flags: VeQItemTableModel.AddChildren | VeQItemTableModel.AddNonLeaves | VeQItemTableModel.DontAddItem
		}

		delegate: Relay {
			serviceUid: model.uid
			relayIndex: model.index
		}
	}
}
