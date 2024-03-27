# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11,12} )

inherit check-reqs cmake flag-o-matic pax-utils python-single-r1 toolchain-funcs xdg-utils

DESCRIPTION="3D Creation/Animation/Publishing System"
HOMEPAGE="https://www.blender.org"

SRC_URI="https://download.blender.org/source/${P}.tar.xz"

# Blender can have letters in the version string,
# so strip off the letter if it exists.
MY_PV="$(ver_cut 1-2)"

SLOT="0"
LICENSE="|| ( GPL-3 BL )"
KEYWORDS="~amd64"
IUSE="+bullet +fluid +openexr +tbb
	alembic collada +color-management cuda +cycles cycles-bin-kernels
	debug doc +embree +ffmpeg +fftw +gmp jack jemalloc jpeg2k
	man +nanovdb ndof nls +oceansim openal oidn +openmp +openpgl +opensubdiv
	+openvdb optix osl +pdf +potrace +pugixml pulseaudio sdl
	+sndfile +tiff valgrind wayland +webp X"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	alembic? ( openexr )
	cuda? ( cycles )
	cycles? ( openexr tbb tiff )
	fluid? ( tbb )
	nanovdb? ( openvdb )
	oceansim? ( fftw tbb )
	openvdb? ( tbb )
	optix? ( cuda )
	osl? ( cycles )"

# Library versions for official builds can be found in the blender source directory in:
# build_files/build_environment/install_deps.sh
RDEPEND="${PYTHON_DEPS}
	app-arch/zstd
	dev-cpp/gflags:=
	dev-cpp/glog[gflags(+)]
	dev-libs/boost:=[nls?]
	dev-libs/lzo:2=
	$(python_gen_cond_dep '
		dev-python/cython[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/zstandard[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	')
	media-libs/fontconfig:=
	media-libs/freetype:=[brotli]
	media-libs/glew:=
	media-libs/libepoxy:=
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/libsamplerate
	>=media-libs/openimageio-2.4.6.0:=
	sys-libs/zlib:=
	virtual/glu
	virtual/libintl
	virtual/opengl
	alembic? ( >=media-gfx/alembic-1.8.3-r2[boost(+),hdf(+)] )
	collada? ( >=media-libs/opencollada-1.6.68 )
	color-management? ( media-libs/opencolorio:= )
	cuda? ( dev-util/nvidia-cuda-toolkit:= )
	cycles? ( media-libs/freeglut )
	embree? ( >=media-libs/embree-3.13.0[raymask] )
	ffmpeg? ( media-video/ffmpeg:=[x264,mp3,encode,theora,jpeg2k?,vpx,vorbis,opus,xvid] )
	fftw? ( sci-libs/fftw:3.0= )
	gmp? ( dev-libs/gmp )
	jack? ( virtual/jack )
	jemalloc? ( dev-libs/jemalloc:= )
	jpeg2k? ( media-libs/openjpeg:2= )
	ndof? (
		app-misc/spacenavd
		dev-libs/libspnav
	)
	nls? ( virtual/libiconv )
	openal? ( media-libs/openal )
	oidn? ( >=media-libs/oidn-1.4.1 )
	openexr? (
		>=dev-libs/imath-3.1.4-r2:=
		>=media-libs/openexr-3:0=
	)
	openpgl? ( >=media-libs/openpgl-0.5.0 )
	opensubdiv? ( >=media-libs/opensubdiv-3.5.0 )
	openvdb? (
		>=media-gfx/openvdb-10.1.0:=[nanovdb?]
		dev-libs/c-blosc:=
	)
	optix? ( <dev-libs/optix-7.5.0 )
	osl? ( >=media-libs/osl-1.11.16.0-r3:= )
	pdf? ( media-libs/libharu )
	potrace? ( media-gfx/potrace )
	pugixml? ( dev-libs/pugixml )
	pulseaudio? ( media-libs/libpulse )
	sdl? ( media-libs/libsdl2[sound,joystick] )
	sndfile? ( media-libs/libsndfile )
	tbb? ( dev-cpp/tbb:= )
	tiff? ( media-libs/tiff:= )
	valgrind? ( dev-util/valgrind )
	wayland? (
		>=dev-libs/wayland-1.12
		>=dev-libs/wayland-protocols-1.15
		>=x11-libs/libxkbcommon-0.2.0
		dev-util/wayland-scanner
		media-libs/mesa[wayland]
		sys-apps/dbus
	)
	X? (
		x11-libs/libX11
		x11-libs/libXi
		x11-libs/libXxf86vm
		x11-libs/libXrender
	)
"

DEPEND="${RDEPEND}
	dev-cpp/eigen:=
"

BDEPEND="
	virtual/pkgconfig
	doc? (
		app-text/doxygen[dot]
		dev-python/sphinx[latex]
		dev-python/sphinx-rtd-theme
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
	nls? ( sys-devel/gettext )
	wayland? (
		dev-util/wayland-scanner
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-2.82-use-system-glog.patch"
	"${FILESDIR}/${PN}-2.92-include-deduplication-check-skip.patch"
)

CMAKE_BUILD_TYPE="Release"

blender_check_requirements() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp

	if use doc; then
		CHECKREQS_DISK_BUILD="4G" check-reqs_pkg_pretend
	fi
}

pkg_pretend() {
	blender_check_requirements
}

pkg_setup() {
	blender_check_requirements
	python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	# Disable MS Windows help generation. The variable doesn't do what it
	# it sounds like.
	sed -e "s|GENERATE_HTMLHELP      = YES|GENERATE_HTMLHELP      = NO|" \
		-i doc/doxygen/Doxyfile || die

	# Remove bundled libraries which must not be used instead of system ones
	rm -rf extern/{Eigen3,glew,lzo,gflags,glog}
}

src_configure() {
	append-lfs-flags

	local mycmakeargs=(
		-DWITH_LIBS_PRECOMPILED=no
		-DBUILD_SHARED_LIBS=no
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
		-DPYTHON_VERSION="${EPYTHON/python/}"
		-DWITH_ALEMBIC=$(usex alembic)
		-DWITH_ASSERT_ABORT=$(usex debug)
		-DWITH_BOOST=yes
		-DWITH_BULLET=$(usex bullet)
		-DWITH_CODEC_FFMPEG=$(usex ffmpeg)
		-DWITH_CODEC_SNDFILE=$(usex sndfile)
		-DWITH_CXX_GUARDEDALLOC=$(usex debug)
		-DWITH_CYCLES=$(usex cycles)
		-DWITH_CYCLES_CUDA_BINARIES=$(usex cuda $(usex cycles-bin-kernels))
		-DWITH_CYCLES_DEVICE_ONEAPI=no
		-DWITH_CYCLES_DEVICE_CUDA=$(usex cuda)
		-DWITH_CYCLES_DEVICE_HIP=no
		-DWITH_CYCLES_DEVICE_OPTIX=$(usex optix)
		-DWITH_CYCLES_EMBREE=$(usex embree)
		-DWITH_CYCLES_HIP_BINARIES=no
		-DWITH_CYCLES_ONEAPI_BINARIES=no
		-DWITH_CYCLES_OSL=$(usex osl)
		-DWITH_CYCLES_PATH_GUIDING=$(usex openpgl)
		-DWITH_CYCLES_STANDALONE=no
		-DWITH_CYCLES_STANDALONE_GUI=no
		-DWITH_DOC_MANPAGE=$(usex man)
		-DWITH_FFTW3=$(usex fftw)
		-DWITH_GHOST_WAYLAND=$(usex wayland)
		-DWITH_GHOST_WAYLAND_APP_ID="blender-${BV}"
		-DWITH_GHOST_WAYLAND_DBUS=$(usex wayland)
		-DWITH_GHOST_WAYLAND_DYNLOAD=no
		-DWITH_GHOST_WAYLAND_LIBDECOR=no
		-DWITH_GHOST_X11=$(usex X)
		-DWITH_GMP=$(usex gmp)
		-DWITH_GTESTS=OFF
		-DWITH_HARU=$(usex pdf)
		-DWITH_HEADLESS=$($(use X || use wayland) && echo OFF || echo ON)
		-DWITH_INSTALL_PORTABLE=no
		-DWITH_IMAGE_OPENEXR=$(usex openexr)
		-DWITH_IMAGE_OPENJPEG=$(usex jpeg2k)
		-DWITH_IMAGE_WEBP=$(usex webp)
		-DWITH_INPUT_NDOF=$(usex ndof)
		-DWITH_INTERNATIONAL=$(usex nls)
		-DWITH_JACK=$(usex jack)
		-DWITH_MATERIALX=no
		-DWITH_MEM_JEMALLOC=$(usex jemalloc)
		-DWITH_MEM_VALGRIND=$(usex valgrind)
		-DWITH_MOD_FLUID=$(usex fluid)
		-DWITH_MOD_OCEANSIM=$(usex oceansim)
		-DWITH_NANOVDB=$(usex nanovdb)
		-DWITH_OPENAL=$(usex openal)
		-DWITH_OPENCOLLADA=$(usex collada)
		-DWITH_OPENCOLORIO=$(usex color-management)
		-DWITH_OPENIMAGEDENOISE=$(usex oidn)
		-DWITH_OPENMP=$(usex openmp)
		-DWITH_OPENSUBDIV=$(usex opensubdiv)
		-DWITH_OPENVDB=$(usex openvdb)
		-DWITH_OPENVDB_BLOSC=$(usex openvdb)
		-DWITH_POTRACE=$(usex potrace)
		-DWITH_PUGIXML=$(usex pugixml)
		-DWITH_PULSEAUDIO=$(usex pulseaudio)
		-DWITH_PYTHON_INSTALL=no
		-DWITH_DRACO=no
		-DWITH_PYTHON_INSTALL_NUMPY=no
		-DWITH_PYTHON_INSTALL_ZSTANDARD=no
		-DWITH_PYTHON_SAFETY=$(usex debug)
		-DWITH_SDL=$(usex sdl)
		-DWITH_STATIC_LIBS=no
		-DWITH_SYSTEM_EIGEN3=yes
		-DWITH_SYSTEM_FREETYPE=yes
		-DWITH_SYSTEM_GFLAGS=yes
		-DWITH_SYSTEM_GLOG=yes
		-DWITH_SYSTEM_LZO=yes
		-DWITH_TBB=$(usex tbb)
		-DWITH_USD=no
		-DWITH_HYDRA=no
		-DWITH_XR_OPENXR=no
	)

	if use optix; then
		mycmakeargs+=(
			-DCYCLES_RUNTIME_OPTIX_ROOT_DIR="${EPREFIX}"/opt/optix
			-DOPTIX_ROOT_DIR="${EPREFIX}"/opt/optix
		)
	fi

	# This is currently needed on arm64 to get the NEON SIMD wrapper to compile the code successfully
	use arm64 && append-flags -flax-vector-conversions

	append-cflags $(usex debug '-DDEBUG' '-DNDEBUG')
	append-cppflags $(usex debug '-DDEBUG' '-DNDEBUG')

	if tc-is-gcc ; then
		# These options only exist when GCC is detected.
		# We disable these to respect the user's choice of linker.
		mycmakeargs+=(
			-DWITH_LINKER_GOLD=no
			-DWITH_LINKER_LLD=no
		)
		# Ease compiling with required gcc similar to cuda_sanitize but for cmake
		use cuda && use cycles-bin-kernels && mycmakeargs+=( -DCUDA_HOST_COMPILER="$(cuda_gccdir)" )
	fi
	if tc-is-clang ; then
		mycmakeargs+=(
			-DWITH_CLANG=yes
			-DWITH_LLVM=yes
		)
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc; then
		# Workaround for binary drivers.
		addpredict /dev/ati
		addpredict /dev/dri
		addpredict /dev/nvidiactl

		einfo "Generating Blender C/C++ API docs ..."
		cd "${CMAKE_USE_DIR}"/doc/doxygen || die
		doxygen -u Doxyfile || die
		doxygen || die "doxygen failed to build API docs."

		cd "${CMAKE_USE_DIR}" || die
		einfo "Generating (BPY) Blender Python API docs ..."
		BLENDER_SYSTEM_SCRIPTS="${CMAKE_USE_DIR}/scripts" \
			BLENDER_SYSTEM_DATAFILES="${CMAKE_USE_DIR}/release/datafiles" \
			"${BUILD_DIR}"/bin/blender --background --python doc/python_api/sphinx_doc_gen.py -noaudio || die "sphinx failed."

		cd "${CMAKE_USE_DIR}"/doc/python_api || die
		sphinx-build sphinx-in BPY_API || die "sphinx failed."
	fi
}

src_install() {
	# Pax mark blender for hardened support.
	pax-mark m "${BUILD_DIR}"/bin/blender

	if use doc; then
		docinto "html/API/python"
		dodoc -r "${CMAKE_USE_DIR}"/doc/python_api/BPY_API/.

		docinto "html/API/blender"
		dodoc -r "${CMAKE_USE_DIR}"/doc/doxygen/html/.
	fi

	cmake_src_install

	# fix doc installdir
	docinto html
	dodoc "${CMAKE_USE_DIR}"/release/text/readme.html
	rm -r "${ED}"/usr/share/doc/blender || die

	python_optimize "${ED}/usr/share/blender/${MY_PV}/scripts"
}

pkg_postinst() {
	elog
	elog "Blender uses python integration. As such, may have some"
	elog "inherent risks with running unknown python scripts."
	elog
	elog "It is recommended to change your blender temp directory"
	elog "from /tmp to /home/user/tmp or another tmp file under your"
	elog "home directory. This can be done by starting blender, then"
	elog "changing the 'Temporary Files' directory in Blender preferences."
	elog
	ewarn
	ewarn "This ebuild does not unbundle the massive amount of 3rd party"
	ewarn "libraries which are shipped with blender. Note that"
	ewarn "these have caused security issues in the past."
	ewarn "If you are concerned about security, file a bug upstream:"
	ewarn "  https://developer.blender.org/"
	ewarn
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update

	ewarn ""
	ewarn "You may want to remove the following directory."
	ewarn "~/.config/${PN}/${MY_PV}/cache/"
	ewarn "It may contain extra render kernels not tracked by portage"
	ewarn ""
}
