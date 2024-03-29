# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop

DESCRIPTION="Removable media mount/unmount daemon and clients"
HOMEPAGE="https://github.com/iDarkTemplar/dtmd"

SRC_URI="https://github.com/iDarkTemplar/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+console +cxx +openrc qt6 +syslog udev"
REQUIRED_USE="qt6? ( cxx )"

DEPEND="
	>=dev-libs/dt-command-2.0.0:=
	qt6? ( dev-qt/qtbase:6[gui,widgets] )
	udev? ( virtual/udev )
	!udev? ( sys-apps/util-linux )
	"

RDEPEND="$DEPEND"

src_configure() {
	local mycmakeargs=(
		-DENABLE_SYSLOG=$(usex syslog)
		-DENABLE_CONSOLE_CLIENT=$(usex console)
		-DENABLE_QT_CLIENT=$(usex qt6)
		-DENABLE_CXX=$(usex cxx)
		-DLINUX_UDEV=$(usex udev)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use openrc ; then
		if ! use udev ; then
			newinitd "${S}/openrc/dtmd.linux.kernel.service" "dtmd"
		else
			newinitd "${S}/openrc/dtmd.linux.udev.service" "dtmd"
		fi
	fi

	if use qt6 ; then
		newicon "${S}/client/qt/images/normal.png" "dtmd-qt.png"
		make_desktop_entry dtmd-qt "dtmd client" "dtmd-qt" "System;Filesystem"
	fi
}
