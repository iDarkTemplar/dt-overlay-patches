# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Collection of tools for working with cgroups"
HOMEPAGE="https://github.com/iDarkTemplar/dt-cgroup-tools"

SRC_URI="https://github.com/iDarkTemplar/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	|| (
		dev-lang/lua:5.4
		dev-lang/lua:5.3
		dev-lang/lua:5.2
		dev-lang/lua:5.1
	)
	"

DEPEND="
	$RDEPEND
	virtual/pkgconfig
	sys-libs/libcap
	"
