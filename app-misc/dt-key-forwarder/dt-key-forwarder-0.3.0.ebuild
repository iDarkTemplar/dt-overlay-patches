# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils cmake-utils

DESCRIPTION="Client/server utility to redirect multimedia keys into different X session"
HOMEPAGE="https://github.com/iDarkTemplar/dt-key-forwarder"

SRC_URI="https://github.com/iDarkTemplar/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	>=dev-libs/dt-command-2.0.0:=
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXtst
	"

RDEPEND="
	$DEPEND
	"

src_configure() {
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}
