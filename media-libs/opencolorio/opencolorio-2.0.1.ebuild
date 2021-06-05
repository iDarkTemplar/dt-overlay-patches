# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )

inherit cmake flag-o-matic python-single-r1

DESCRIPTION="A color management framework for visual effects and animation"
HOMEPAGE="https://opencolorio.org/"
SRC_URI="https://github.com/imageworks/OpenColorIO/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/OpenColorIO-${PV}"

LICENSE="BSD"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"
IUSE="apps cpu_flags_x86_sse2 python test"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"

RDEPEND="
	dev-cpp/pystring
	>=dev-cpp/yaml-cpp-0.6.3
	dev-libs/expat
	media-libs/ilmbase:=
	apps? (
		media-libs/lcms:2
		media-libs/openimageio
		media-libs/glew:=
		media-libs/freeglut
		virtual/opengl
	)
	python? (
		${PYTHON_DEPS}
	)
"

DEPEND="${RDEPEND}
	python? (
		$(python_gen_cond_dep '
			dev-python/pybind11[${PYTHON_USEDEP}]
			test? ( dev-python/numpy[${PYTHON_USEDEP}] )
		')
	)
"

BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${P}-install.patch"
)

CMAKE_BUILD_TYPE="Release"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	# Filter -ffp-contract=fast
	# https://github.com/AcademySoftwareFoundation/OpenColorIO/issues/1361
	filter-flags -ffp-contract=fast && append-flags -ffp-contract=on -DNDEBUG

	# Missing features:
	# - Truelight and Nuke are not in portage for now, so their support are disabled
	# - Java bindings was not tested, so disabled
	# - Documentation is disabled due to missing requirements
	# - GPU tests do not work in sandbox
	# Notes:
	# - OpenImageIO is required for building ociodisplay and ocioconvert (USE apps)
	# - OpenGL, GLUT and GLEW is required for building ociodisplay (USE apps)
	local mycmakeargs=(
		-DLIB_SUFFIX=""
		-DBUILD_SHARED_LIBS=ON
		-DOCIO_BUILD_APPS=$(usex apps)
		-DOCIO_BUILD_DOCS=OFF
		-DOCIO_BUILD_GPU_TESTS=OFF
		-DOCIO_BUILD_NUKE=OFF
		-DOCIO_BUILD_PYTHON=$(usex python)
		-DOCIO_BUILD_TESTS=$(usex test)
		-DOCIO_INSTALL_EXT_PACKAGES=NONE
		-DOCIO_USE_SSE=$(usex cpu_flags_x86_sse2)
		-DOCIO_WARNING_AS_ERROR=OFF
	)

	cmake_src_configure
}
