# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN=hexahop

DESCRIPTION="a hexagonal tile-based puzzle game"
HOMEPAGE="http://hexahop.sourceforge.net/"
SRC_URI="mirror://sourceforge/${MY_PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/libsdl
	media-libs/sdl-mixer
	media-libs/sdl-pango
	media-libs/sdl-ttf"
DEPEND="${RDEPEND}"

src_prepare() {
	eapply "${FILESDIR}/${PN}-fullscreen-commandline.patch"
	eapply_user
}

src_install() {
	default

	insinto /usr/share/pixmaps
	doins "${FILESDIR}/hex-a-hop.xpm"

	insinto /usr/share/applications
	doins "${FILESDIR}/hex-a-hop.desktop"
}
