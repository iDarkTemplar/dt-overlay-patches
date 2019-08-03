# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils cmake-utils

DESCRIPTION="Removable media mount/unmount daemon and clients"
HOMEPAGE="https://github.com/iDarkTemplar/dtmd"

SRC_URI="https://github.com/iDarkTemplar/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE="+console +cxx +openrc qt5 +syslog udev kernel_linux kernel_FreeBSD"

REQUIRED_USE="
	qt5? ( cxx )
	"

DEPEND="
	dev-libs/dt-command:=

	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)

	kernel_linux? (
		udev? ( virtual/udev )
		!udev? ( sys-apps/util-linux )
	)

	kernel_FreeBSD? ( sys-freebsd/freebsd-lib )
	"

RDEPEND="
	$DEPEND
	"

src_configure() {
	local mycmakeargs=(
		-DENABLE_SYSLOG=$(usex syslog)
		-DENABLE_CONSOLE_CLIENT=$(usex console)
		-DENABLE_QT_CLIENT=$(usex qt5)
		-DENABLE_CXX=$(usex cxx)
		-DLINUX_UDEV=$(usex udev)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use openrc ; then
		if ! use udev ; then
			newinitd "${S}/openrc/dtmd.linux.kernel.service" "dtmd"
		else
			newinitd "${S}/openrc/dtmd.linux.udev.service" "dtmd"
		fi
	fi

	if use qt5 ; then
		newicon "${S}/client/qt/images/normal.png" "dtmd-qt.png"
		make_desktop_entry dtmd-qt "dtmd client" "dtmd-qt" "System;Filesystem"
	fi
}
