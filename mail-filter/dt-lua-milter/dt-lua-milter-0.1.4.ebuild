# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Mail filter based on libmilter allowing to run custom lua scripts"
HOMEPAGE="https://github.com/iDarkTemplar/dt-lua-milter"

SRC_URI="https://github.com/iDarkTemplar/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+openrc"

DEPEND="
	mail-filter/libmilter:=
	dev-lang/lua:=
	"

RDEPEND="
	$DEPEND
	"

src_install() {
	cmake_src_install

	if use openrc ; then
		newinitd "${S}/openrc/dt-lua-milter.service" "dt-lua-milter"
		newconfd "${S}/openrc/dt-lua-milter.conf" "dt-lua-milter"
	fi
}
