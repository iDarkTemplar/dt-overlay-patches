# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE="qtbase"
inherit qt5-build-multilib

DESCRIPTION="Network abstraction library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
fi

IUSE="bindist connman examples libproxy libressl networkmanager +ssl"

DEPEND="
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.5[${MULTILIB_USEDEP}]
	connman? ( ~dev-qt/qtdbus-${PV}[${MULTILIB_USEDEP}] )
	libproxy? ( net-libs/libproxy[${MULTILIB_USEDEP}] )
	networkmanager? ( ~dev-qt/qtdbus-${PV}[${MULTILIB_USEDEP}] )
	ssl? ( dev-libs/openssl:0=[bindist=,${MULTILIB_USEDEP}] )
	ssl? (
		!libressl? ( dev-libs/openssl:0=[bindist=,${MULTILIB_USEDEP}] )
		libressl? ( dev-libs/libressl:0=[${MULTILIB_USEDEP}] )
	)
"
RDEPEND="${DEPEND}
	connman? ( net-misc/connman )
	networkmanager? ( net-misc/networkmanager )
"

PDEPEND="
	examples? (
		~dev-qt/qtbase-examples-${PV}
	)
"

QT5_TARGET_SUBDIRS=(
	src/network
	src/plugins/bearer/generic
)

QT5_GENTOO_CONFIG=(
	libproxy
	ssl::SSL
	ssl::OPENSSL
	ssl:openssl-linked:LINKED_OPENSSL
)

QT5_GENTOO_PRIVATE_CONFIG=(
	:network
)

pkg_setup() {
	use connman && QT5_TARGET_SUBDIRS+=(src/plugins/bearer/connman)
	use networkmanager && QT5_TARGET_SUBDIRS+=(src/plugins/bearer/networkmanager)
}

multilib_src_configure() {
	local myconf=(
		$(use connman || use networkmanager && echo -dbus-linked)
		$(qt_use libproxy)
		$(usex ssl -openssl-linked '')
	)
	qt5_multilib_src_configure
}
