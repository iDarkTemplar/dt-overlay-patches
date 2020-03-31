# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils cmake-multilib

DESCRIPTION="Simple library for parsing text commands of simple format"
HOMEPAGE="https://github.com/iDarkTemplar/dt-command"

SRC_URI="https://github.com/iDarkTemplar/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

DEPEND="
	"

RDEPEND="
	$DEPEND
	"
