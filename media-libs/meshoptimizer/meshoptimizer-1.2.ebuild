# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Mesh optimization library that makes meshes smaller and faster to render"
HOMEPAGE="https://meshoptimizer.org/"

SRC_URI="https://github.com/zeux/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""

RDEPEND="$DEPEND"

src_configure() {
	local mycmakeargs=(
		-DMESHOPT_BUILD_SHARED_LIBS=ON
	)

	cmake_src_configure
}
