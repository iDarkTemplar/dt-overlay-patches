# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE="qtbase"
inherit qt5-build-multilib

DESCRIPTION="Qt5 module for inter-process communication over the D-Bus protocol"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
fi

IUSE="examples"

DEPEND="
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	>=sys-apps/dbus-1.4.20[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

PDEPEND="
	examples? (
		~dev-qt/qtbase-examples-${PV}
	)
"

QT5_TARGET_SUBDIRS=(
	src/dbus
	src/tools/qdbusxml2cpp
	src/tools/qdbuscpp2xml
)

QT5_GENTOO_CONFIG=(
	:dbus
	:dbus-linked:
)

multilib_src_configure() {
	local myconf=(
		-dbus-linked
	)
	qt5_multilib_src_configure
}
