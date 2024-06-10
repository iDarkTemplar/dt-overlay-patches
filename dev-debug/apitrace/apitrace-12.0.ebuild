# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
PYTHON_COMPAT=( python3_{10..12} )
inherit cmake-multilib python-single-r1

LIBBACKTRACE_COMMIT="8602fda"

DESCRIPTION="Tool for tracing, analyzing, and debugging graphics APIs"
HOMEPAGE="https://github.com/apitrace/apitrace"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/ianlancetaylor/libbacktrace/tarball/${LIBBACKTRACE_COMMIT} -> ${P}-libbacktrace.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="qt6 X"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	app-arch/brotli:=[${MULTILIB_USEDEP}]
	>=app-arch/snappy-1.1.1:=[${MULTILIB_USEDEP}]
	media-libs/libpng:0=
	media-libs/mesa[egl(+),gles1(+),gles2(+),X?,${MULTILIB_USEDEP}]
	>=media-libs/waffle-1.6.0-r1[egl(+),${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	sys-process/procps:=[${MULTILIB_USEDEP}]
	X? ( x11-libs/libX11 )
	qt6? ( dev-qt/qtbase:6[gui,network,widgets] )
"
RDEPEND="${DEPEND}"

PATCHES=(
	# TODO: upstream
	"${FILESDIR}"/${PN}-9.0-disable-multiarch.patch
	"${FILESDIR}"/${PN}-12.0-build.patch
	"${FILESDIR}"/${PN}-11.1-waffle-build.patch
)

src_prepare() {
	cmake_src_prepare

	# prepare libbacktrace
	rm -rf thirdparty/libbacktrace
	mv "${WORKDIR}/ianlancetaylor-libbacktrace-${LIBBACKTRACE_COMMIT}" "${S}/thirdparty/libbacktrace"

	# The apitrace code grubs around in the internal zlib structures.
	# We have to extract this header and clean it up to keep that working.
	# Do not be surprised if a zlib upgrade breaks things ...
	rm -rf thirdparty/{brotli,snappy,snappy.cmake,getopt,less,libpng,zlib,dxerr,directxtex,devcon} || die
}

src_configure() {
	my_configure() {
		local mycmakeargs=(
			-DDOC_INSTALL_DIR="${EPREFIX}"/usr/share/doc/${PF}
			-DENABLE_X11=$(usex X)
			-DENABLE_EGL=ON
			-DENABLE_CLI=ON
			-DENABLE_GUI=$(multilib_native_usex qt6)
			-DENABLE_QT6=$(multilib_native_usex qt6)
			-DENABLE_STATIC_SNAPPY=OFF
			-DENABLE_WAFFLE=ON
			-DBUILD_TESTING=OFF
		)
		cmake_src_configure
	}

	multilib_foreach_abi my_configure
}

src_install() {
	MULTILIB_CHOST_TOOLS=(
		/usr/bin/apitrace$(get_exeext)
		/usr/bin/eglretrace$(get_exeext)
		/usr/bin/gltrim$(get_exeext)
	)
	use X && MULTILIB_CHOST_TOOLS+=( /usr/bin/glretrace$(get_exeext) )

	cmake-multilib_src_install

	make_libgl_symlinks() {
		dosym glxtrace.so /usr/$(get_libdir)/${PN}/wrappers/libGL.so
		dosym glxtrace.so /usr/$(get_libdir)/${PN}/wrappers/libGL.so.1
		dosym glxtrace.so /usr/$(get_libdir)/${PN}/wrappers/libGL.so.1.2
	}
	use X && multilib_foreach_abi make_libgl_symlinks
}
