# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Qt module to access CAN, ModBus, and other industrial serial buses and protocols"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~x86"
fi

IUSE=""

DEPEND="
	~dev-qt/qtbase-${PV}:6=[network]
	~dev-qt/qtserialport-${PV}:6=
"
RDEPEND="${DEPEND}"
