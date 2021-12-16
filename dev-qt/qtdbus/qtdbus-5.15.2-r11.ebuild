# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_COMMIT=7c6c0030cf80ef7b9ace42996b0e0c3a72f76860
QT5_MODULE="qtbase"
inherit qt5-build

DESCRIPTION="Qt5 module for inter-process communication over the D-Bus protocol"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"
fi

IUSE="doc examples"

DEPEND="
	=dev-qt/qtcore-${QT5_PV}*:5=
	>=sys-apps/dbus-1.4.20
"
RDEPEND="${DEPEND}"

PDEPEND="
	doc? (
		=dev-qt/qtbase-doc-${QT5_PV}*
	)
	examples? (
		=dev-qt/qtbase-examples-${QT5_PV}*
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

QT5_GENTOO_PRIVATE_CONFIG=(
	:dbus
	:dbus-linked
)

src_configure() {
	local myconf=(
		-dbus-linked
	)
	qt5-build_src_configure
}
