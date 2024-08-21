/*
** Copyright (C) 2023 Victron Energy B.V.
** See LICENSE.txt for license information.
*/

import QtQuick
import Victron.VenusOS
import QtQuick.Controls.impl as CP

ListQuantityGroupNavigationItem {
	id: root

	property BaseDevice device
	property BaseDeviceModel sourceModel

	text: device.name
}
