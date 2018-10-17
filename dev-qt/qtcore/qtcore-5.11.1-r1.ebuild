# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE="qtbase"
inherit qt5-build-multilib

DESCRIPTION="Cross-platform application development framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc x86 ~amd64-fbsd"
fi

IUSE="examples icu systemd"

DEPEND="
	dev-libs/double-conversion:=[${MULTILIB_USEDEP}]
	dev-libs/glib:2[${MULTILIB_USEDEP}]
	dev-libs/libpcre2[pcre16,unicode,${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	icu? ( dev-libs/icu:=[${MULTILIB_USEDEP}] )
	!icu? ( virtual/libiconv[${MULTILIB_USEDEP}] )
	systemd? ( sys-apps/systemd:=[${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}
	!<dev-qt/qtcore-4.8.7-r4:4
"

PDEPEND="
	examples? (
		~dev-qt/qtbase-examples-${PV}
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-5.9.2-examples.patch"
)

QT5_TARGET_SUBDIRS=(
	src/tools/bootstrap
	src/tools/moc
	src/tools/rcc
	src/tools/qfloat16-tables
	src/corelib
	src/tools/qlalr
	doc
)

QT5_GENTOO_PRIVATE_CONFIG=(
	!:network
	!:sql
	!:testlib
	!:xml
)

multilib_src_configure() {
	local myconf=(
		$(qt_use icu)
		$(qt_use !icu iconv)
		$(qt_use systemd journald)
	)
	qt5_multilib_src_configure
}

multilib_src_install() {
	qt5_multilib_src_install

	local flags=(
		ALSA CUPS DBUS EGL EGLFS EGL_X11 EVDEV FONTCONFIG FREETYPE
		HARFBUZZ IMAGEFORMAT_JPEG IMAGEFORMAT_PNG LIBPROXY MITSHM
		OPENGL OPENSSL OPENVG PULSEAUDIO SHAPE SSL TSLIB WIDGETS
		XCURSOR	XFIXES XKB XRANDR XRENDER XSYNC ZLIB
	)

	for flag in ${flags[@]}; do
		cat >> "${D%/}"/${QT5_HEADERDIR}/QtCore/qconfig.h <<- _EOF_ || die

			#if defined(QT_NO_${flag}) && defined(QT_${flag})
			# undef QT_NO_${flag}
			#elif !defined(QT_NO_${flag}) && !defined(QT_${flag})
			# define QT_NO_${flag}
			#endif
		_EOF_
	done
}
