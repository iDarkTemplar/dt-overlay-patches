# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 )

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
IUSE="+bullet +dds +fluid +openexr +tbb \
	alembic collada +color-management cuda +cycles \
	debug doc +embree +ffmpeg +fftw +gmp headless jack jemalloc jpeg2k \
	man +nanovdb ndof nls +oceansim openal oidn +openimageio +openmp +opensubdiv \
	+openvdb +osl +pdf +potrace +pugixml pulseaudio sdl +sndfile +tiff valgrind"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	alembic? ( openexr )
	cuda? ( cycles )
	cycles? ( openexr tbb tiff openimageio )
	fluid? ( tbb )
	oceansim? ( fftw tbb )
	openvdb? ( tbb )
	osl? ( cycles )"

# Library versions for official builds can be found in the blender source directory in:
# build_files/build_environment/install_deps.sh
RDEPEND="${PYTHON_DEPS}
	dev-cpp/gflags:=
	dev-cpp/glog[gflags(+)]
	dev-libs/boost:=[nls?,threads(+)]
	dev-libs/lzo:2=
	$(python_gen_cond_dep '
		dev-python/cython[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/zstandard[${PYTHON_USEDEP}]
	')
	media-libs/fontconfig:=
	media-libs/freetype:=
	media-libs/glew:=
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/libsamplerate
	sys-libs/zlib:=
	virtual/glu
	virtual/libintl
	virtual/opengl
	alembic? ( >=media-gfx/alembic-1.8.3-r2[boost(+),hdf(+)] )
	collada? ( >=media-libs/opencollada-1.6.68:= )
	color-management? ( >=media-libs/opencolorio-2.1.1-r7:= )
	cuda? ( dev-util/nvidia-cuda-toolkit:= )
	cycles? ( media-libs/freeglut )
	embree? ( >=media-libs/embree-3.10.0[raymask] )
	ffmpeg? ( media-video/ffmpeg:=[x264,mp3,encode,theora,jpeg2k?,vpx,vorbis,opus,xvid] )
	fftw? ( sci-libs/fftw:3.0= )
	gmp? ( dev-libs/gmp )
	!headless? (
		x11-libs/libX11
		x11-libs/libXi
		x11-libs/libXxf86vm
		x11-libs/libXrender
	)
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
	openimageio? ( >=media-libs/openimageio-2.3.12.0-r3:= )
	openexr? (
		>=dev-libs/imath-3.1.4-r2:=
		>=media-libs/openexr-3:=
	)
	opensubdiv? ( >=media-libs/opensubdiv-3.4.0:=[cuda=] )
	openvdb? (
		>=media-gfx/openvdb-9.0.0:=[nanovdb?]
		dev-libs/c-blosc:=
	)
	osl? ( >=media-libs/osl-1.11.16.0-r3:= )
	pdf? ( media-libs/libharu )
	potrace? ( media-gfx/potrace )
	pugixml? ( dev-libs/pugixml )
	pulseaudio? ( media-sound/pulseaudio )
	sdl? ( media-libs/libsdl2[sound,joystick] )
	sndfile? ( media-libs/libsndfile )
	tbb? ( dev-cpp/tbb:= )
	tiff? ( media-libs/tiff )
	valgrind? ( dev-util/valgrind )
"

DEPEND="${RDEPEND}
	dev-cpp/eigen:=
"

BDEPEND="
	virtual/pkgconfig
	doc? (
		app-doc/doxygen[dot]
		dev-python/sphinx[latex]
		dev-python/sphinx_rtd_theme
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
	nls? ( sys-devel/gettext )
"

PATCHES=(
	"${FILESDIR}/${PN}-2.82-use-system-glog.patch"
	"${FILESDIR}/${PN}-2.92-include-deduplication-check-skip.patch"
	"${FILESDIR}/${PN}-2.80-fix-install-rules.patch"
	"${FILESDIR}/${PN}-3.2.0-doc.patch"
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
		-DBUILD_SHARED_LIBS=OFF
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
		-DPYTHON_VERSION="${EPYTHON/python/}"
		-DWITH_ALEMBIC=$(usex alembic)
		-DWITH_ASSERT_ABORT=$(usex debug)
		-DWITH_BOOST=ON
		-DWITH_BULLET=$(usex bullet)
		-DWITH_CODEC_FFMPEG=$(usex ffmpeg)
		-DWITH_CODEC_SNDFILE=$(usex sndfile)
		-DWITH_CXX_GUARDEDALLOC=$(usex debug)
		-DWITH_CYCLES=$(usex cycles)
		-DWITH_CYCLES_DEVICE_CUDA=$(usex cuda TRUE FALSE)
		-DWITH_CYCLES_EMBREE=$(usex embree)
		-DWITH_CYCLES_OSL=$(usex osl)
		-DWITH_CYCLES_STANDALONE=OFF
		-DWITH_CYCLES_STANDALONE_GUI=OFF
		-DWITH_DOC_MANPAGE=$(usex man)
		-DWITH_FFTW3=$(usex fftw)
		-DWITH_GHOST_X11=$(usex !headless)
		-DWITH_GMP=$(usex gmp)
		-DWITH_GTESTS=OFF
		-DWITH_HARU=$(usex pdf)
		-DWITH_HEADLESS=$(usex headless)
		-DWITH_INSTALL_PORTABLE=OFF
		-DWITH_IMAGE_DDS=$(usex dds)
		-DOPENEXR_ROOT_DIR="${ESYSROOT}/usr/$(get_libdir)/OpenEXR-3"
		-DWITH_IMAGE_OPENEXR=$(usex openexr)
		-DWITH_IMAGE_OPENJPEG=$(usex jpeg2k)
		-DWITH_IMAGE_TIFF=$(usex tiff)
		-DWITH_INPUT_NDOF=$(usex ndof)
		-DWITH_INTERNATIONAL=$(usex nls)
		-DWITH_JACK=$(usex jack)
		-DWITH_MEM_JEMALLOC=$(usex jemalloc)
		-DWITH_MEM_VALGRIND=$(usex valgrind)
		-DWITH_MOD_FLUID=$(usex fluid)
		-DWITH_MOD_OCEANSIM=$(usex oceansim)
		-DWITH_NANOVDB=$(usex nanovdb)
		-DWITH_OPENAL=$(usex openal)
		-DWITH_OPENCOLLADA=$(usex collada)
		-DWITH_OPENCOLORIO=$(usex color-management)
		-DWITH_OPENIMAGEDENOISE=$(usex oidn)
		-DWITH_OPENIMAGEIO=$(usex openimageio)
		-DWITH_OPENMP=$(usex openmp)
		-DWITH_OPENSUBDIV=$(usex opensubdiv)
		-DWITH_OPENVDB=$(usex openvdb)
		-DWITH_OPENVDB_BLOSC=$(usex openvdb)
		-DWITH_POTRACE=$(usex potrace)
		-DWITH_PUGIXML=$(usex pugixml)
		-DWITH_PULSEAUDIO=$(usex pulseaudio)
		-DWITH_PYTHON_INSTALL=OFF
		-DWITH_PYTHON_INSTALL_NUMPY=OFF
		-DWITH_PYTHON_SAFETY=$(usex debug)
		-DWITH_SDL=$(usex sdl)
		-DWITH_STATIC_LIBS=OFF
		-DWITH_SYSTEM_EIGEN3=ON
		-DWITH_SYSTEM_FREETYPE=ON
		-DWITH_SYSTEM_GFLAGS=ON
		-DWITH_SYSTEM_GLEW=ON
		-DWITH_SYSTEM_GLOG=ON
		-DWITH_SYSTEM_LZO=ON
		-DWITH_TBB=$(usex tbb)
		-DWITH_USD=OFF
		-DWITH_XR_OPENXR=OFF
	)

	append-flags $(usex debug '-DDEBUG' '-DNDEBUG')

	if tc-is-gcc ; then
		# These options only exist when GCC is detected.
		# We disable these to respect the user's choice of linker.
		mycmakeargs+=(
			-DWITH_LINKER_GOLD=OFF
			-DWITH_LINKER_LLD=OFF
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
		BLENDER_SYSTEM_SCRIPTS="${CMAKE_USE_DIR}/release/scripts" \
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
