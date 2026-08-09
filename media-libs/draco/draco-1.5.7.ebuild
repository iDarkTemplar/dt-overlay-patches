# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Library for compressing and decompressing 3D geometric meshes and point clouds"
HOMEPAGE="https://github.com/google/draco"

SRC_URI="https://github.com/google/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0/9"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""

RDEPEND="$DEPEND"

PATCHES=(
	"${FILESDIR}/${PN}-1.5.7-no-exe-symlinks.patch"
	"${FILESDIR}/${PN}-1.5.7-no-static-lib.patch"
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
	)

	cmake_src_configure
}
