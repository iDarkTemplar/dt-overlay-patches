# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Splashscreen wrapper for fsck"
HOMEPAGE="https://github.com/iDarkTemplar/fsck-splash"

SRC_URI="https://github.com/iDarkTemplar/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	sys-boot/plymouth
	"

RDEPEND="
	$DEPEND
	"

BDEPEND="
	virtual/pkgconfig
	"
