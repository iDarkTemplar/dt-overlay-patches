EAPI=5

inherit eutils cmake-utils

DESCRIPTION="Removable media mount/unmount daemon and clients"
HOMEPAGE="https://github.com/iDarkTemplar/dtmd"

SRC_URI="https://github.com/iDarkTemplar/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-fbsd ~x86-fbsd"
IUSE="+console +cxx +openrc qt4 qt5 +syslog udev +mtab"

REQUIRED_USE="
	qt4? ( cxx )
	qt5? ( cxx )
	?? ( qt4 qt5 )
	"

DEPEND="
	dev-libs/dt-command:=
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
	)

	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)

	udev? ( virtual/udev )
	!udev? ( sys-apps/util-linux )
	"

RDEPEND="
	$DEPEND
	"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable syslog SYSLOG)
		$(cmake-utils_use_with mtab MTAB_WRITEABLE)
		$(cmake-utils_use_enable console CONSOLE_CLIENT)
		$(cmake-utils_use_enable cxx CXX)
	)

	if use qt5 ; then
		mycmakeargs+=" -DCLIENT_QT=5"
	elif use qt4 ; then
		mycmakeargs+=" -DCLIENT_QT=4"
	else
		mycmakeargs+=" -DCLIENT_QT=0"
	fi

	if use udev ; then
		mycmakeargs+=" -DLINUX_UDEV=1"
	else
		mycmakeargs+=" -DLINUX_UDEV=0"
	fi

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

	if use qt4 || use qt5 ; then
		newicon "${S}/client/qt/images/normal.png" "dtmd-qt.png"
		make_desktop_entry dtmd-qt "dtmd client" "dtmd-qt" "System;Filesystem"
	fi
}
