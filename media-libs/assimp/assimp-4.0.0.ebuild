# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib versionator multilib

DESCRIPTION="Importer library to import assets from 3D files"
HOMEPAGE="https://github.com/assimp/assimp"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="samples static test tools"
SLOT="0"

RDEPEND="
	dev-libs/boost[${MULTILIB_USEDEP}]
	samples? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		virtual/opengl[${MULTILIB_USEDEP}]
		media-libs/freeglut[${MULTILIB_USEDEP}]
	)
	sys-libs/zlib[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest[${MULTILIB_USEDEP}] )
"

PATCHES=( "${FILESDIR}/findassimp-${PV}.patch" )

multilib_src_configure() {
	local mycmakeargs=(
		-DASSIMP_BUILD_SAMPLES=$(multilib_native_usex samples) \
		-DASSIMP_BUILD_ASSIMP_TOOLS=$(multilib_native_usex tools) \
		-DASSIMP_BUILD_STATIC_LIB=$(usex static) \
		-DASSIMP_BUILD_TESTS=$(usex test)
		-DCMAKE_DEBUG_POSTFIX=""
		-DASSIMP_LIB_INSTALL_DIR="${EPREFIX}/usr/$(get_libdir)/"
	)

	cmake-utils_src_configure
}

multilib_src_install() {
	cmake-utils_src_install
}

multilib_src_install_all() {
	insinto /usr/share/cmake/Modules
	doins cmake-modules/Findassimp.cmake
}

multilib_src_test() {
	"${BUILD_DIR}/test/unit" || die
}
