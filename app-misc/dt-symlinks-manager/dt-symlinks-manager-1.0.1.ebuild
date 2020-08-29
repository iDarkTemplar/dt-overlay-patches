# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils cmake

DESCRIPTION="A utility to manage symlinks similar to eselect"
HOMEPAGE="https://github.com/iDarkTemplar/dt-symlinks-manager"

SRC_URI="https://github.com/iDarkTemplar/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="boost"

DEPEND="
	boost? ( dev-libs/boost:= )
	"

RDEPEND="
	$DEPEND
	"

src_configure() {
	local mycmakeargs=(
		-DUSE_BOOST=$(usex boost)
	)

	cmake_src_configure
}
