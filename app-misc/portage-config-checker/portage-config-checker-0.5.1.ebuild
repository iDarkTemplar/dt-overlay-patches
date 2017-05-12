# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils cmake-utils

DESCRIPTION="Portage Config Checker"
HOMEPAGE="https://github.com/iDarkTemplar/portage-config-checker"

SRC_URI="https://github.com/iDarkTemplar/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

DEPEND="
	dev-libs/boost:=
	"

RDEPEND="
	$DEPEND
	"
