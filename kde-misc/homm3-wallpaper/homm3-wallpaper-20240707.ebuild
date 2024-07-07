# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Animated wallpaper for KDE displaying HOMM3 map"
HOMEPAGE="https://github.com/iDarkTemplar/homm3-wallpaper"

SRC_URI="https://github.com/iDarkTemplar/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+utils"

COMMON_DEPEND="
	sys-libs/zlib:=
	dev-qt/qtbase:6=[gui(+),opengl(+)]
	dev-qt/qtdeclarative:6=
	"

DEPEND="${COMMON_DEPEND}
	dev-libs/boost
	kde-plasma/libplasma:6
	"

RDEPEND="${COMMON_DEPEND}
	kde-frameworks/kirigami:6
	"

src_configure() {
	local mycmakeargs=(
		-DVIEWER=$(usex utils)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	dodoc README
	dodoc LICENSE.txt
	dodoc LICENSE.GPLv3.txt
	dodoc LICENSE.LGPLv3.txt

	docinto vcmi
	dodoc vcmi/license.txt
	dodoc vcmi/AUTHORS
}
