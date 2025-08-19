# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit xdg-utils

DESCRIPTION="Crystal Remix: a remixed Crystal icon theme for KDE Plasma 5"
HOMEPAGE="https://github.com/dangvd/crystal_remix"
SRC_URI="https://github.com/dangvd/crystal_remix/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE=""

RESTRICT="strip binchecks"

src_install() {
	local themedir=/usr/share/icons/crystal-remix

	dodoc README

	insinto ${themedir}

	doins index.theme

	doins -r 32x32
	doins -r 48x48
	doins -r 128x128
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
