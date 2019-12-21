# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit qt5-build

DESCRIPTION="Qt module to access CAN, ModBus, and other industrial serial buses and protocols"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 x86"
fi

IUSE="examples"

DEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtnetwork-${PV}
	~dev-qt/qtserialport-${PV}
	examples? (
		~dev-qt/qtwidgets-${PV}
	)
"
RDEPEND="${DEPEND}"

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples")
}
