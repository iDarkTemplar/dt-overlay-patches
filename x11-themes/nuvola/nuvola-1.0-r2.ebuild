# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit xdg-utils

DESCRIPTION="Nuvola SVG icon theme"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=5358"
SRC_URI="https://web.archive.org/web/20070114072052if_/http://www.icon-king.com/files/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE=""

RESTRICT="strip binchecks"

DEPEND="!=kde-apps/kdeartwork-iconthemes-4*"

S=${WORKDIR}

src_install() {
	cd nuvola
	dodoc thanks.to readme.txt author
	rm thanks.to thanks.to~ readme.txt author license.txt

	cd "${S}"
	insinto /usr/share/icons
	doins -r nuvola
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
