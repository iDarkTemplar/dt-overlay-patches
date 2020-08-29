# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils

DESCRIPTION="A script for combining parts of multiple git repositories"
HOMEPAGE="https://github.com/iDarkTemplar/dt-patches-mixer"

SRC_URI="https://github.com/iDarkTemplar/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+gpg +portage"

DEPEND="
	"

RDEPEND="
	$DEPEND
	dev-vcs/git[gpg?]
	"

src_install() {
	dobin "${S}/dt-patches-mixer"

	insinto /etc
	doins "${S}/dt-patches-mixer.conf"

	if use portage ; then
		exeinto "/etc/portage/postsync.d"
		doexe "${S}/dt-patches-mixer-sync"
	fi
}
