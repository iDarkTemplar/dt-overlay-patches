# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils

DESCRIPTION="Reliable MTP client with minimalistic UI"
HOMEPAGE="https://whoozle.github.io/android-file-transfer-linux/"
SRC_URI="https://github.com/whoozle/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fuse qt4 qt5 +magic"
REQUIRED_USE="
	?? ( qt4 qt5 )
	"

RDEPEND="fuse? ( sys-fs/fuse )
	qt4? ( dev-qt/qtgui:4 )
	qt5? ( dev-qt/qtwidgets:5 )
	magic? ( sys-apps/file )
	"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	"

src_prepare() {
	eapply "${FILESDIR}/${PN}-3.1-shared-library.patch"
	eapply_user
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_FUSE=$(usex fuse)
		-DBUILD_SHARED_LIB=ON
		-DUSB_BACKEND_LIBUSB=OFF
	)

	if use qt4 || use qt5 ; then
		mycmakeargs+=(
			-DBUILD_QT_UI=ON
		)
	fi

	if use qt4 ; then
		mycmakeargs+=(
			-DDESIRED_QT_VERSION=4
		)
	fi

	if use qt5 ; then
		mycmakeargs+=(
			-DDESIRED_QT_VERSION=5
		)
	fi

	cmake-utils_src_configure
}
