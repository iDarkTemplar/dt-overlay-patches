EAPI=5

inherit multilib multilib-build scons-utils toolchain-funcs eutils

DESCRIPTION="A tool for OpenGL debugging"
HOMEPAGE="http://www.opengl.org/sdk/tools/BuGLe/"
SRC_URI="mirror://sourceforge/bugle/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE+="ffmpeg gtk"

COMMON_DEPEND="ffmpeg? ( virtual/ffmpeg )
	gtk? ( x11-libs/gtk+:2 x11-libs/gtkglext )
	virtual/opengl
	media-libs/glew
	media-libs/freeglut
	>=dev-lang/python-2.6
	>=dev-lang/perl-5
	abi_x86_32? (
		gtk? ( app-emulation/emul-linux-x86-gtklibs )
		ffmpeg? ( app-emulation/emul-linux-x86-medialibs )
	)"
DEPEND+="${COMMON_DEPEND}
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}"

src_prepare() {
	# Fix Sandbox violation
	sed -i "s/install_env.AddPostAction(targets, SCons.Action.Action('-ldconfig', '"'$LDCONFIGCOMSTR'"'))/True/" "${S}/site_scons/site_tools/buglewrappers.py" || die

	multilib_copy_sources
}

# Despite all my efforts, I simply haven't yet found a reliable way to pass
# an ABI-specific variable (myesconsargs) to my_src_compile(). Associative
# array somehow doesn't work and variable in variable name doesn't seemingly
# expand correctly.
my_src_configure() {
	local prefix="/usr"
	local my_CC="$(tc-getCC)"
	local my_CXX="$(tc-getCXX)"
	local my_CCFLAGS=""
	local my_LINKFLAGS="${LDFLAGS}"
	local bindir="${prefix}/bin"

	if [[ "${my_CC}" =~ '-m32' ]]; then
		my_CCFLAGS+=" -m32"
		my_LINKFLAGS+=" -m32"
		use abi_x86_64 && bindir+="32"
	fi

	# prefix must not contain ${D} because it will be recorded in
	# pkg-config files and other program components

	# We use config=debug to prevent bugle from automatically adding
	# "-s" to linker flags ( src/SConscript, apply_compiler() ), the cost
	# is it then adds "-g".

	# bugle directly calls CC/CXX using Python Popen, so they must not contain
	# -m32, etc.
	myesconsargs=(
		CC="${my_CC/ -m32}"
		CXX="${my_CXX/ -m32}"
		CFLAGS="${CFLAGS}"
		CXXFLAGS="${CXXFLAGS}"
		CCFLAGS="${my_CCFLAGS/# }"
		LINKFLAGS="${my_LINKFLAGS/# }"
		config=debug
		prefix="${prefix}"
		docdir="${prefix}/share/doc/${PF}"
		libdir="${prefix}/$(get_libdir)"
		bindir="${bindir}"
		)

	# Disable GTK+ unless on the best variant
	# [[ ${MULTIBUILD_VARIANTS} ]] \
	# 	|| die "MULTIBUILD_VARIANTS need to be set"
	# local bestabi="${MULTIBUILD_VARIANTS[$(( ${#MULTIBUILD_VARIANTS[@]} - 1))]}"

	# (! use gtk || [ "${bestabi}" != "${MULTIBUILD_VARIANT}" ]) \

	! use gtk && myesconsargs+=( "without_gtk=yes" "without_gtkglext=yes" )
	! use ffmpeg && myesconsargs+=( "without_lavc=yes" )

	# eval "myesconsargs_${ABI}=\"\${myesconsargs[@]}\""
}

src_compile() {
	my_src_compile() {
		my_src_configure
		escons
	}
	multilib_foreach_abi my_src_compile
}


src_install() {
	my_src_install() {
		my_src_configure
		escons install --install-sandbox="${ED}"
		multilib_check_headers
	}
	multilib_foreach_abi my_src_install

	dodoc NEWS README
	dodoc -r "${S}/doc/examples"
}

