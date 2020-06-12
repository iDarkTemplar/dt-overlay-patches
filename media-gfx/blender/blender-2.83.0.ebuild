# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit check-reqs cmake-utils xdg-utils flag-o-matic xdg-utils \
	pax-utils python-single-r1 toolchain-funcs

DESCRIPTION="3D Creation/Animation/Publishing System"
HOMEPAGE="https://www.blender.org"

SRC_URI="https://download.blender.org/source/${P}.tar.xz"

# Blender can have letters in the version string,
# so strip off the letter if it exists.
MY_PV="$(ver_cut 1-2)"

SLOT="0"
LICENSE="|| ( GPL-2 BL )"
KEYWORDS="~amd64 ~x86"
IUSE="+bullet +dds +elbeem +openexr collada color-management \
	cuda cycles debug doc ffmpeg fftw headless jack jemalloc jpeg2k \
	llvm man ndof nls oceansim openal opencl openimageio openmp opensubdiv openvdb \
	osl sdl sndfile +tbb test tiff valgrind"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	cuda? ( cycles )
	cycles? ( openexr tiff openimageio )
	elbeem? ( tbb )
	oceansim? ( fftw tbb )
	opencl? ( cycles )
	openvdb? ( tbb )
	osl? ( cycles llvm )"

RDEPEND="${PYTHON_DEPS}
	dev-cpp/gflags:=
	dev-cpp/glog[gflags(+)]
	>=dev-libs/boost-1.62:=[nls?,threads(+)]
	dev-libs/lzo:2
	$(python_gen_cond_dep '
		>=dev-python/numpy-1.10.1[${PYTHON_MULTI_USEDEP}]
		dev-python/requests[${PYTHON_MULTI_USEDEP}]
	' python3_7 python3_8)
	media-libs/freetype
	media-libs/glew:*
	media-libs/libpng:0=
	media-libs/libsamplerate
	sys-libs/zlib
	virtual/glu
	virtual/jpeg:0=
	virtual/libintl
	virtual/opengl
	collada? ( >=media-libs/opencollada-1.6.18:= )
	color-management? ( media-libs/opencolorio )
	cuda? ( dev-util/nvidia-cuda-toolkit:= )
	ffmpeg? ( media-video/ffmpeg:=[x264,mp3,encode,theora,jpeg2k?] )
	fftw? ( sci-libs/fftw:3.0= )
	!headless? (
		x11-libs/libX11
		x11-libs/libXi
		x11-libs/libXxf86vm
		x11-libs/libXrender
	)
	jack? ( virtual/jack )
	jemalloc? ( dev-libs/jemalloc:= )
	jpeg2k? ( media-libs/openjpeg:2 )
	llvm? ( sys-devel/llvm:= )
	ndof? (
		app-misc/spacenavd
		dev-libs/libspnav
	)
	nls? ( virtual/libiconv )
	openal? ( media-libs/openal )
	opencl? ( virtual/opencl )
	openimageio? ( >=media-libs/openimageio-1.7.0 )
	openexr? (
		>=media-libs/ilmbase-2.2.0:=
		>=media-libs/openexr-2.2.0:=
	)
	opensubdiv? ( >=media-libs/opensubdiv-3.3.0:=[cuda=,opencl=] )
	openvdb? (
		media-gfx/openvdb[${PYTHON_SINGLE_USEDEP},-abi3-compat(-),abi4-compat(+)]
		>=dev-libs/c-blosc-1.5.2
	)
	osl? ( media-libs/osl:= )
	sdl? ( media-libs/libsdl2[sound,joystick] )
	sndfile? ( media-libs/libsndfile )
	tbb? ( dev-cpp/tbb )
	tiff? ( media-libs/tiff:0 )
	valgrind? ( dev-util/valgrind )"

DEPEND="${RDEPEND}
	>=dev-cpp/eigen-3.2.8:3
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
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}/${PN}-2.82-use-system-glog.patch"
	"${FILESDIR}/${PN}-2.80-alt-include-deduplication-check-skip.patch"
	"${FILESDIR}/${PN}-2.80-fix-install-rules.patch"
)

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
	cmake-utils_src_prepare

	# we don't want static glew, but it's scattered across
	# multiple files that differ from version to version
	# !!!CHECK THIS SED ON EVERY VERSION BUMP!!!
	local file
	while IFS="" read -d $'\0' -r file ; do
		sed -i -e '/-DGLEW_STATIC/d' "${file}" || die
	done < <(find . -type f -name "CMakeLists.txt")

	# Disable MS Windows help generation. The variable doesn't do what it
	# it sounds like.
	sed -e "s|GENERATE_HTMLHELP      = YES|GENERATE_HTMLHELP      = NO|" \
	    -i doc/doxygen/Doxyfile || die

	# Remove bundled libraries which must not be used instead of system ones
	rm -rf extern/{Eigen3,glew,glew-es,lzo,gflags,glog}
}

src_configure() {
	# FIX: forcing '-funsigned-char' fixes an anti-aliasing issue with menu
	# shadows, see bug #276338 for reference
	append-flags -funsigned-char
	append-lfs-flags
	# Blender is compatible ABI 4 or less, so use ABI 4.
	append-cppflags -DOPENVDB_ABI_VERSION_NUMBER=4

	local mycmakeargs=(
		-DPYTHON_VERSION="${EPYTHON/python/}"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DWITH_INSTALL_PORTABLE=OFF
		-DWITH_PYTHON_INSTALL=OFF
		-DWITH_PYTHON_INSTALL_NUMPY=OFF
		-DWITH_STATIC_LIBS=OFF
		-DWITH_SYSTEM_GLEW=ON
		-DWITH_SYSTEM_EIGEN3=ON
		-DWITH_SYSTEM_LZO=ON
		-DWITH_SYSTEM_GFLAGS=ON
		-DWITH_SYSTEM_GLOG=ON
		-DWITH_BOOST=ON
		-DWITH_BULLET=$(usex bullet)
		-DWITH_CODEC_FFMPEG=$(usex ffmpeg)
		-DWITH_CODEC_SNDFILE=$(usex sndfile)
		-DWITH_CUDA_DYNLOAD=$(usex cuda)
		-DWITH_CYCLES_DEVICE_CUDA=$(usex cuda TRUE FALSE)
		-DWITH_CYCLES_DEVICE_OPENCL=$(usex opencl TRUE FALSE)
		-DWITH_CYCLES=$(usex cycles)
		-DWITH_CYCLES_OSL=$(usex osl)
		-DWITH_LLVM=$(usex llvm)
		-DWITH_FFTW3=$(usex fftw)
		-DWITH_HEADLESS=$(usex headless)
		-DWITH_X11=$(usex !headless)
		-DWITH_IMAGE_DDS=$(usex dds)
		-DWITH_IMAGE_OPENEXR=$(usex openexr)
		-DWITH_IMAGE_OPENJPEG=$(usex jpeg2k)
		-DWITH_IMAGE_TIFF=$(usex tiff)
		-DWITH_INPUT_NDOF=$(usex ndof)
		-DWITH_INTERNATIONAL=$(usex nls)
		-DWITH_JACK=$(usex jack)
		-DWITH_MOD_FLUID=$(usex elbeem)
		-DWITH_MOD_OCEANSIM=$(usex oceansim)
		-DWITH_OPENAL=$(usex openal)
		-DWITH_OPENCOLORIO=$(usex color-management)
		-DWITH_OPENCOLLADA=$(usex collada)
		-DWITH_OPENIMAGEIO=$(usex openimageio)
		-DWITH_OPENMP=$(usex openmp)
		-DWITH_OPENSUBDIV=$(usex opensubdiv)
		-DWITH_OPENVDB=$(usex openvdb)
		-DWITH_OPENVDB_BLOSC=$(usex openvdb)
		-DWITH_SDL=$(usex sdl)
		-DWITH_CXX_GUARDEDALLOC=$(usex debug)
		-DWITH_ASSERT_ABORT=$(usex debug)
		-DWITH_GTESTS=$(usex test)
		-DWITH_DOC_MANPAGE=$(usex man)
		-DWITH_MEM_JEMALLOC=$(usex jemalloc)
		-DWITH_MEM_VALGRIND=$(usex valgrind)
		-DWITH_TBB=$(usex tbb)
		-DBUILD_SHARED_LIBS=OFF
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

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

src_test() {
	if use test; then
		einfo "Running Blender Unit Tests ..."
		cd "${BUILD_DIR}"/bin/tests || die
		local f
		for f in *_test; do
			./"${f}" || die
		done
	fi
}

src_install() {
	# Pax mark blender for hardened support.
	pax-mark m "${CMAKE_BUILD_DIR}"/bin/blender

	if use doc; then
		docinto "html/API/python"
		dodoc -r "${CMAKE_USE_DIR}"/doc/python_api/BPY_API/.

		docinto "html/API/blender"
		dodoc -r "${CMAKE_USE_DIR}"/doc/doxygen/html/.
	fi

	cmake-utils_src_install

	# fix doc installdir
	docinto "html"
	dodoc "${CMAKE_USE_DIR}"/release/text/readme.html
	rm -r "${ED%/}"/usr/share/doc/blender || die

	python_fix_shebang "${ED%/}/usr/bin/blender-thumbnailer.py"
	python_optimize "${ED%/}/usr/share/blender/${MY_PV}/scripts"
}

pkg_postinst() {
	elog
	elog "Blender uses python integration. As such, may have some"
	elog "inherit risks with running unknown python scripts."
	elog
	elog "It is recommended to change your blender temp directory"
	elog "from /tmp to /home/user/tmp or another tmp file under your"
	elog "home directory. This can be done by starting blender, then"
	elog "dragging the main menu down do display all paths."
	elog
	ewarn
	ewarn "This ebuild does not unbundle the massive amount of 3rd party"
	ewarn "libraries which are shipped with blender. Note that"
	ewarn "these have caused security issues in the past."
	ewarn "If you are concerned about security, file a bug upstream:"
	ewarn "  https://developer.blender.org/"
	ewarn
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update

	ewarn ""
	ewarn "You may want to remove the following directory."
	ewarn "~/.config/${PN}/${MY_PV}/cache/"
	ewarn "It may contain extra render kernels not tracked by portage"
	ewarn ""
}