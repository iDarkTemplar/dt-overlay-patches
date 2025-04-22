# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
# NOTE must match media-libs/osl
LLVM_COMPAT=( {18..19} )
LLVM_OPTIONAL=1

ROCM_SKIP_GLOBALS=1

inherit cuda rocm llvm-r1
inherit check-reqs flag-o-matic pax-utils python-single-r1 toolchain-funcs
inherit cmake xdg-utils

DESCRIPTION="3D Creation/Animation/Publishing System"
HOMEPAGE="https://www.blender.org"

SRC_URI="https://download.blender.org/source/${P}.tar.xz"

# Blender can have letters in the version string,
# so strip off the letter if it exists.
MY_PV="$(ver_cut 1-2)"

SLOT="0"
# assets is CC0-1.0
LICENSE="GPL-3+ cycles? ( Apache-2.0 ) CC0-1.0"
KEYWORDS="~amd64"
IUSE="
	alembic +bullet collada +color-management cuda +cycles cycles-bin-kernels
	debug doc +embree experimental +ffmpeg +fftw +fluid +gmp gnome hip jack
	jemalloc jpeg2k man +nanovdb ndof nls +oceansim oidn openal +openexr +opengl +openmp +openpgl
	+opensubdiv +openvdb optix osl pipewire +pdf +potrace +pugixml pulseaudio
	renderdoc sdl +sndfile +tbb +tiff +truetype valgrind vulkan wayland +webp X"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	|| ( opengl vulkan )
	alembic? ( openexr )
	cuda? ( cycles )
	cycles? ( openexr tiff tbb )
	fluid? ( tbb )
	gnome? ( wayland )
	hip? ( cycles )
	nanovdb? ( openvdb )
	oceansim? ( fftw tbb )
	openvdb? ( tbb openexr )
	optix? ( cuda )
	osl? ( cycles pugixml )"

# Library versions for official builds can be found in the blender source directory in:
# build_files/build_environment/cmake/versions.cmake
RDEPEND="${PYTHON_DEPS}
	app-arch/zstd
	dev-cpp/gflags:=
	dev-cpp/glog:=[gflags(+)]
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
	>=media-libs/openimageio-2.5.6.0:=
	sys-libs/zlib:=
	virtual/glu
	virtual/libintl
	virtual/opengl[X?]
	alembic? ( >=media-gfx/alembic-1.8.3-r2[boost(+),hdf(+)] )
	bullet? ( sci-physics/bullet:=[double-precision] )
	collada? ( >=media-libs/opencollada-1.6.68 )
	color-management? ( media-libs/opencolorio:= )
	cuda? ( dev-util/nvidia-cuda-toolkit:= )
	embree? ( media-libs/embree:=[raymask] )
	ffmpeg? ( media-video/ffmpeg:=[encode(+),lame(-),jpeg2k?,opus,theora,vorbis,vpx,x264,xvid] )
	fftw? ( sci-libs/fftw:3.0=[threads] )
	gmp? ( dev-libs/gmp[cxx] )
	gnome? ( gui-libs/libdecor )
	hip? (
		>=dev-util/hip-5.7:=
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
	oidn? ( >=media-libs/oidn-2.1.0 )
	openexr? (
		>=dev-libs/imath-3.1.7:=
		>=media-libs/openexr-3.2.1:0=
	)
	openpgl? ( media-libs/openpgl:= )
	opensubdiv? ( >=media-libs/opensubdiv-3.6.0-r2[opengl,cuda?,openmp?,tbb?] )
	openvdb? (
		>=media-gfx/openvdb-11.0.0:=[nanovdb?]
		dev-libs/c-blosc:=
	)
	optix? ( dev-libs/optix )
	osl? (
		>=media-libs/osl-1.13:=[${LLVM_USEDEP}]
		media-libs/mesa[${LLVM_USEDEP}]
	)
	pdf? ( media-libs/libharu )
	potrace? ( media-gfx/potrace )
	pugixml? ( dev-libs/pugixml )
	pulseaudio? ( media-libs/libpulse )
	sdl? ( media-libs/libsdl2[sound,joystick] )
	sndfile? ( media-libs/libsndfile )
	tbb? ( dev-cpp/tbb:= )
	tiff? ( media-libs/tiff:= )
	valgrind? ( dev-debug/valgrind )
	wayland? (
		>=dev-libs/wayland-1.12
		>=dev-libs/wayland-protocols-1.15
		>=x11-libs/libxkbcommon-0.2.0
		dev-util/wayland-scanner
		media-libs/mesa[wayland]
		sys-apps/dbus
	)
	vulkan? (
		media-libs/shaderc
		dev-util/spirv-tools
		dev-util/glslang
		media-libs/vulkan-loader
	)
	truetype? (
		media-libs/harfbuzz
	)
	renderdoc? (
		media-gfx/renderdoc
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
	vulkan? (
		dev-util/spirv-headers
		dev-util/vulkan-headers
	)
	nls? ( sys-devel/gettext )
	wayland? (
		dev-util/wayland-scanner
	)
	X? (
		x11-base/xorg-proto
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-4.0.2-FindClang.patch"
	"${FILESDIR}/${PN}-4.1.1-FindLLVM.patch"
	"${FILESDIR}/${PN}-4.1.1-numpy.patch"
	"${FILESDIR}/${PN}-4.3.2-system-gtest.patch"
	"${FILESDIR}/${PN}-4.4.0-optix-compile-flags.patch"
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

	if use osl; then
		llvm-r1_pkg_setup
	fi
}

src_prepare() {
	use cuda && cuda_src_prepare

	cmake_src_prepare

	sed \
		-e "s#\(set(cycles_kernel_runtime_lib_target_path \)\${cycles_kernel_runtime_lib_target_path}\(/lib)\)#\1\${CYCLES_INSTALL_PATH}\2#" \
		-i intern/cycles/kernel/CMakeLists.txt \
		|| die

	if use hip; then
		# fix hardcoded path
		sed \
			-e "s#opt/rocm/hip/bin#$(hipconfig -p)/bin#g" \
			-i extern/hipew/src/hipew.c \
			|| die
	fi

	cmake_comment_add_subdirectory tests

	# Remove bundled libraries which must not be used instead of system ones
	rm -rf extern/{Eigen3,glew,lzo,gflags,glog}
}

src_configure() {
	# -Werror=odr, -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/859607
	# https://projects.blender.org/blender/blender/issues/120444
	filter-lto

	# Workaround for bug #922600
	append-ldflags $(test-flags-CCLD -Wl,--undefined-version)

	append-lfs-flags

	local mycmakeargs=(
		# we build a host-specific binary
		-DWITH_CPU_CHECK="no"

		-DWITH_STRICT_BUILD_OPTIONS="yes"
		-DWITH_LIBS_PRECOMPILED="no"
		-DBUILD_SHARED_LIBS="no" # quadriflow only?
		-DWITH_STATIC_LIBS=OFF

		# Build Options:
		-DWITH_ALEMBIC="$(usex alembic)"
		-DWITH_BOOST="yes"
		-DWITH_BULLET="$(usex bullet)"
		-DWITH_CYCLES="$(usex cycles)"
		-DWITH_DOC_MANPAGE="$(usex man)"
		-DWITH_FFTW3="$(usex fftw)"
		-DWITH_GMP="$(usex gmp)"
		-DWITH_GTESTS=OFF
		-DWITH_HARFBUZZ="$(usex truetype)"
		-DWITH_HARU="$(usex pdf)"
		-DWITH_HEADLESS="$(usex !X "$(use !wayland)")"
		-DWITH_INPUT_NDOF="$(usex ndof)"
		-DWITH_INTERNATIONAL="$(usex nls)"
		-DWITH_MATERIALX="no" # TODO: Package MaterialX
		-DWITH_NANOVDB="$(usex nanovdb)"
		-DWITH_OPENCOLLADA="$(usex collada)"
		-DWITH_OPENCOLORIO="$(usex color-management)"
		-DWITH_OPENGL_BACKEND="$(usex opengl)"
		-DWITH_OPENIMAGEDENOISE="$(usex oidn)"
		-DWITH_OPENSUBDIV="$(usex opensubdiv)"
		-DWITH_OPENVDB="$(usex openvdb)"
		-DWITH_OPENVDB_BLOSC="$(usex openvdb)"
		-DWITH_POTRACE="$(usex potrace)"
		-DWITH_PUGIXML="$(usex pugixml)"
		# -DWITH_QUADRIFLOW=ON
		-DWITH_RENDERDOC="$(usex renderdoc)"
		-DWITH_TBB="$(usex tbb)"
		-DWITH_UNITY_BUILD="no"
		-DWITH_USD="no" # TODO: Package USD
		-DWITH_VULKAN_BACKEND="$(usex vulkan)" # experimental
		-DWITH_XR_OPENXR="no"

		-DWITH_SYSTEM_BULLET="yes"
		-DWITH_SYSTEM_EIGEN3="yes"
		-DWITH_SYSTEM_FREETYPE="yes"
		-DWITH_SYSTEM_GFLAGS="yes"
		-DWITH_SYSTEM_GLOG="yes"
		-DWITH_SYSTEM_LZO="yes"

		# Compiler Options:
		-DWITH_BUILDINFO="no"
		-DWITH_OPENMP="$(usex openmp)"

		# System Options:
		-DWITH_INSTALL_PORTABLE="no"
		-DWITH_MEM_JEMALLOC="$(usex jemalloc)"
		-DWITH_MEM_VALGRIND="$(usex valgrind)"

		# GHOST Options:
		-DWITH_GHOST_WAYLAND="$(usex wayland)"
		-DWITH_GHOST_WAYLAND_APP_ID="blender-${BV}"
		-DWITH_GHOST_WAYLAND_DYNLOAD="no"
		-DWITH_GHOST_X11="$(usex X)"
		# -DWITH_GHOST_XDND=ON
		# -DWITH_X11_XF86VMODE=ON
		# -DWITH_X11_XFIXES=ON
		# -DWITH_X11_XINPUT=ON
		# -DWITH_GHOST_WAYLAND_DYNLOAD # visible wayland?
		# -DWITH_GHOST_WAYLAND_LIBDECOR # visible wayland?

		# Image Formats:
		# -DWITH_IMAGE_CINEON=ON
		-DWITH_IMAGE_OPENEXR="$(usex openexr)"
		-DWITH_IMAGE_OPENJPEG="$(usex jpeg2k)"
		-DWITH_IMAGE_WEBP="$(usex webp)" # unlisted

		# Audio:
		# -DWITH_AUDASPACE=OFF
		# -DWITH_SYSTEM_AUDASPACE=OFF
		-DWITH_CODEC_FFMPEG="$(usex ffmpeg)"
		-DWITH_CODEC_SNDFILE="$(usex sndfile)"
		# -DWITH_COREAUDIO=OFF
		-DWITH_JACK="$(usex jack)"
		# -DWITH_JACK_DYNLOAD=
		-DWITH_OPENAL="$(usex openal)"
		-DWITH_PIPEWIRE="$(usex pipewire)"
		# -DWITH_PIPEWIRE_DYNLOAD=
		-DWITH_PULSEAUDIO="$(usex pulseaudio)"
		# -DWITH_PULSEAUDIO_DYNLOAD=
		-DWITH_SDL="$(usex sdl)"
		# -DWITH_WASAPI=OFF

		# Python:
		# -DWITH_PYTHON=ON
		-DWITH_PYTHON_INSTALL="no"
		# -DWITH_PYTHON_INSTALL_NUMPY="no"
		# -DWITH_PYTHON_INSTALL_ZSTANDARD="no"
		# -DWITH_PYTHON_MODULE="no"
		-DWITH_PYTHON_SAFETY=$(usex debug)
		-DWITH_PYTHON_SECURITY="yes"
		-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
		-DPYTHON_LIBRARY="$(python_get_library_path)"
		-DPYTHON_VERSION="${EPYTHON/python/}"
		-DWITH_DRACO="no" # TODO: Package Draco

		# Modifiers:
		-DWITH_MOD_FLUID="$(usex fluid)"
		# -DWITH_MOD_REMESH=ON
		-DWITH_MOD_OCEANSIM="$(usex oceansim)"

		# Rendering:
		-DWITH_HYDRA="no" # TODO: Package Hydra

		# Rendering (Cycles):
		-DWITH_CYCLES_OSL="$(usex osl)"
		-DWITH_CYCLES_EMBREE="$(usex embree)"
		-DWITH_CYCLES_PATH_GUIDING="$(usex openpgl)"

		-DWITH_CYCLES_DEVICE_OPTIX="$(usex optix)"
		-DWITH_CYCLES_DEVICE_CUDA="$(usex cuda)"
		-DWITH_CYCLES_CUDA_BINARIES="$(usex cuda "$(usex cycles-bin-kernels)")"

		-DWITH_CYCLES_DEVICE_HIP="$(usex hip)"
		-DWITH_CYCLES_HIP_BINARIES="$(usex hip "$(usex cycles-bin-kernels)")"
		-DWITH_CYCLES_HYDRA_RENDER_DELEGATE="no" # TODO: package Hydra

		# -DWITH_CYCLES_STANDALONE=OFF
		# -DWITH_CYCLES_STANDALONE_GUI=OFF

		-DWITH_BLENDER_THUMBNAILER="yes"

		-DWITH_ASSERT_ABORT=$(usex debug)
		-DWITH_EXPERIMENTAL_FEATURES="$(usex experimental)"
	)

	if has_version ">=dev-python/numpy-2"; then
		mycmakeargs+=(
			-DPYTHON_NUMPY_INCLUDE_DIRS="$(python_get_sitedir)/numpy/_core/include"
			-DPYTHON_NUMPY_PATH="$(python_get_sitedir)/numpy/_core/include"
		)
	fi

	if use cuda; then
		# Ease compiling with required gcc similar to cuda_sanitize but for cmake
		if use cycles-bin-kernels; then
			local -x CUDAHOSTCXX="$(cuda_gccdir)"
			local -x CUDAHOSTLD="$(tc-getCXX)"

			if [[ -n "${CUDAARCHS}" ]]; then
				mycmakeargs+=(
					-DCYCLES_CUDA_BINARIES_ARCH="$(echo "${CUDAARCHS}" | sed -e 's/^/sm_/g' -e 's/;/;sm_/g')"
				)
			fi
		fi
	fi

	if use hip; then
		# local -x HIP_PATH="$(hipconfig -p)"
		mycmakeargs+=(
			# -DROCM_PATH="$(hipconfig -R)"
			-DHIP_ROOT_DIR="$(hipconfig -p)"

			-DHIP_HIPCC_FLAGS="-fcf-protection=none"

			# -DHIP_LINKER_EXECUTABLE="$(get_llvm_prefix)/bin/clang++"
			-DCMAKE_HIP_LINK_EXECUTABLE="$(get_llvm_prefix)/bin/clang++"

			-DCYCLES_HIP_BINARIES_ARCH="$(get_amdgpu_flags)"
		)
	fi

	if use optix; then
		mycmakeargs+=(
			-DCYCLES_RUNTIME_OPTIX_ROOT_DIR="${ESYSROOT}/opt/optix"
			-DOPTIX_ROOT_DIR="${ESYSROOT}/opt/optix"
		)
	fi

	if use wayland; then
		mycmakeargs+=(
			-DWITH_GHOST_WAYLAND_APP_ID="blender-${MY_PV}"
			-DWITH_GHOST_WAYLAND_LIBDECOR="$(usex gnome)"
		)
	fi

	# This is currently needed on arm64 to get the NEON SIMD wrapper to compile the code successfully
	use arm64 && append-flags -flax-vector-conversions

	append-cflags "$(usex debug '-DDEBUG' '-DNDEBUG')"
	append-cxxflags "$(usex debug '-DDEBUG' '-DNDEBUG')"

	if tc-is-gcc; then
		# We disable these to respect the user's choice of linker.
		mycmakeargs+=(
			-DWITH_LINKER_GOLD="no"
		)
	fi

	if tc-is-clang || use osl; then
		mycmakeargs+=(
			-DWITH_CLANG="yes"
			-DWITH_LLVM="yes"
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
		BLENDER_SYSTEM_RESOURCES="${CMAKE_USE_DIR}/" \
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

	# Fix doc installdir
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

	if use osl && ! has_version "media-libs/mesa[${LLVM_USEDEP}]"; then
		ewarn ""
		ewarn "OSL is known to cause runtime segfaults if Mesa has been linked to"
		ewarn "an other LLVM version than what OSL is linked to."
		ewarn "See https://bugs.gentoo.org/880671 for more details"
		ewarn ""
	fi

	# NOTE build_files/cmake/Modules/FindPythonLibsUnix.cmake: set(_PYTHON_VERSION_SUPPORTED 3.11)
	if ! use python_single_target_python3_11; then
		elog "You are building Blender with a newer python version than"
		elog "supported by this version upstream."
		elog "If you experience breakages with e.g. plugins, please switch to"
		elog "PYTHON_SINGLE_TARGET: python3_11 instead."
		elog "Bug: https://bugs.gentoo.org/737388"
		elog
	fi

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
