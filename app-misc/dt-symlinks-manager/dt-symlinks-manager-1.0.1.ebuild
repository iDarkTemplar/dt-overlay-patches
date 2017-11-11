# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils cmake-utils

DESCRIPTION="A utility to manage symlinks similar to eselect"
HOMEPAGE="https://github.com/iDarkTemplar/dt-symlinks-manager"

SRC_URI="https://github.com/iDarkTemplar/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-fbsd ~x86-fbsd"
IUSE="boost"

DEPEND="
	boost? ( dev-libs/boost:= )
	"

RDEPEND="
	$DEPEND
	"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_use boost BOOST)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}
