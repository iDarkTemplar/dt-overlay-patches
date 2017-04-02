# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils

DESCRIPTION="Reliable MTP client with minimalistic UI"
HOMEPAGE="https://whoozle.github.io/android-file-transfer-linux/"

SRC_URI="https://github.com/whoozle/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE="fuse gui static"

RDEPEND="
	fuse? ( sys-fs/fuse )
	gui? (
		|| (
			dev-qt/qtwidgets:5
			dev-qt/qtgui:4
		)
	)
	"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	"

#S=${WORKDIR}/${P}

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.4-shared-library.patch"
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build gui QT_UI)
	)

	if ! use static; then
		mycmakeargs=(
			${mycmakeargs}
			-DBUILD_SHARED_LIB=ON
		)
	fi

	cmake-utils_src_configure
}
