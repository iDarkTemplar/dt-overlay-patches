EAPI=4

inherit eutils scons-utils toolchain-funcs multilib

DESCRIPTION="OpenGL debugger"
HOMEPAGE="http://www.opengl.org/sdk/tools/BuGLe/"

SRC_URI="http://sourceforge.net/projects/bugle/files/bugle/${PV}/bugle-${PV}.tar.bz2/download -> bugle-${PV}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+debugger +video test +doc"

RDEPEND="
	>=sys-devel/gcc-4.1
	sys-libs/readline
	dev-lang/python:2.7
	virtual/opengl
	sys-devel/libperl
	dev-util/scons

	video? (
		virtual/ffmpeg
	)

	debugger? (
		x11-libs/gtk+:2
		x11-libs/gtkglext
		media-libs/glew
	)

	test? (
		media-libs/freeglut
	)
	"

DEPEND="${RDEPEND}"

src_configure() {
	local my_args="parts=interceptor"
	if use debugger ; then
		my_args="${my_args},debugger"
	fi

	if use doc ; then
		my_args="${my_args},docs"
	fi

	if use test ; then
		my_args="${my_args},tests"
	fi

        local mycflags=$(printf "%s " ${CPPFLAGS} ${CFLAGS} | sed -e 's: $::')
        local mycxxflags=$(printf "%s " ${CPPFLAGS} ${CXXFLAGS} | sed -e 's: $::')
        local myldflags=$(printf "%s " ${LDFLAGS} | sed -e 's: $::')

	myesconsargs=(
		"CC=$(tc-getCC)"
		"CXX=$(tc-getCXX)"
		"CFLAGS=${mycflags}"
		"CXXFLAGS=${mycxxflags}"
		"LINKFLAGS=${myldflags}"
		"prefix=/usr"
		"libdir=/usr/$(get_libdir)"
		"${my_args}"
	)
}

src_compile() {
	escons
}

src_test() {
	escons test
}

src_install() {
	local build_dir="${S}/build/*"

	# install libraries
	dolib ${build_dir}/libbugleutils.so.8.0.2
	dolib ${build_dir}/libbugleutils.so.8
	dolib ${build_dir}/libbugleutils.so

	dolib ${build_dir}/libbugle.so.10.0.0
	dolib ${build_dir}/libbugle.so.10
	dolib ${build_dir}/libbugle.so

	exeinto /usr/$(get_libdir)/bugle
	doexe ${build_dir}/filters/*.so

	# install headers
	insinto /usr/include/bugle/bugle
	doins ${S}/src/include/bugle/*.h
	doins ${build_dir}/include/bugle/porting.h

	insinto /usr/include/bugle/bugle/egl
	doins ${S}/src/include/bugle/egl/*.h

        insinto /usr/include/bugle/bugle/gl
        doins ${S}/src/include/bugle/gl/*.h

        insinto /usr/include/bugle/bugle/glwin
        doins ${S}/src/include/bugle/glwin/*.h

        insinto /usr/include/bugle/bugle/glx
        doins ${S}/src/include/bugle/glx/*.h

        insinto /usr/include/bugle/bugle/wgl
        doins ${S}/src/include/bugle/wgl/*.h

	insinto /usr/include/bugle/budgie
	doins ${S}/src/include/budgie/*.h
	doins ${build_dir}/include/budgie/*.h

	# install man pages
	doman ${S}/doc/DocBook/man/man3/*.3
	doman ${S}/doc/DocBook/man/man5/*.5
	doman ${S}/doc/DocBook/man/man7/*.7

	# install pkg-config data
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${build_dir}/bugle.pc

	if use debugger ; then
		dobin ${build_dir}/gldb/gldb-gui

		# install man
		doman ${S}/doc/DocBook/man/man1/gldb-gui.1
	fi

	if use doc ; then
		insinto /usr/share/bugle-${PV}
		doins ${S}/build/doc/html/single.html
		doins ${S}/build/doc/html/bugle.css
		doins -r ${S}/build/doc/html/chunked
	fi
}
