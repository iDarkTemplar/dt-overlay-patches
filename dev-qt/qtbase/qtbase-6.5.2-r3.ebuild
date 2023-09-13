# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build-extra toolchain-funcs

DESCRIPTION="Cross-platform application development framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

# Qt Modules
IUSE="+concurrent +dbus +gui +network +sql +opengl +xml +widgets zstd"
REQUIRED_USE="
	opengl? ( gui )
	widgets? ( gui )
	X? ( || ( evdev libinput ) )
"

QTGUI_IUSE="accessibility egl eglfs evdev +gif gles2-only +ico +jpeg +libinput png tslib tuio vulkan +X"
QTNETWORK_IUSE="brotli connman gssapi libproxy networkmanager sctp +ssl vnc"
QTSQL_IUSE="freetds mysql oci8 odbc postgres +sqlite"
IUSE+=" ${QTGUI_IUSE} ${QTNETWORK_IUSE} ${QTSQL_IUSE} cups doc examples gtk icu systemd +udev"

# QtPrintSupport = QtGui + QtWidgets enabled.
# ibus = xkbcommon + dbus, and xkbcommon needs either libinput or X
# moved vnc logically to QtNetwork as that is upstream condition for it
REQUIRED_USE+="
	$(printf '%s? ( gui ) ' ${QTGUI_IUSE//+/})
	$(printf '%s? ( network ) ' ${QTNETWORK_IUSE//+/})
	$(printf '%s? ( sql ) ' ${QTSQL_IUSE//+/})
	accessibility? ( dbus X )
	connman? ( dbus )
	cups? ( gui widgets )
	eglfs? ( egl )
	gtk? ( widgets )
	gui? ( || ( eglfs X ) || ( libinput X ) )
	libinput? ( udev )
	networkmanager? ( dbus )
	sql? ( || ( freetds mysql oci8 odbc postgres sqlite ) )
	X? ( gles2-only? ( egl ) )
"

BDEPEND="
	app-text/xmlstarlet
	"

DEPEND="
	app-crypt/libb2
	dev-libs/double-conversion:=
	dev-libs/glib:2
	dev-libs/libpcre2:=[pcre16,unicode]
	media-libs/tiff:0
	sys-libs/zlib:=
	brotli? ( app-arch/brotli:= )
	cups? ( >=net-print/cups-1.4 )
	dbus? ( >=sys-apps/dbus-1.4.20 )
	egl? ( media-libs/mesa[egl(+)] )
	eglfs? (
		media-libs/mesa[gbm(+)]
		x11-libs/libdrm
	)
	evdev? ( sys-libs/mtdev )
	freetds? ( dev-db/freetds )
	gles2-only? ( media-libs/libglvnd )
	!gles2-only? ( media-libs/libglvnd[X] )
	gui? (
		dev-util/gtk-update-icon-cache
		media-libs/fontconfig
		>=media-libs/freetype-2.6.1:2
		>=media-libs/harfbuzz-1.6.0:=
	)
	gssapi? ( virtual/krb5 )
	gtk? (
		x11-libs/gtk+:3
		x11-libs/libX11
		x11-libs/pango
	)
	gui? ( media-libs/libpng:0= )
	icu? ( dev-libs/icu:= )
	!icu? ( virtual/libiconv )
	jpeg? ( media-libs/libjpeg-turbo:= )
	libinput? (
		dev-libs/libinput:=
		>=x11-libs/libxkbcommon-0.5.0
	)
	libproxy? ( net-libs/libproxy )
	mysql? ( dev-db/mysql-connector-c:= )
	oci8? ( dev-db/oracle-instantclient:=[sdk] )
	odbc? ( dev-db/unixODBC )
	png? ( media-libs/libpng:0= )
	postgres? ( dev-db/postgresql:* )
	sctp? ( net-misc/lksctp-tools )
	sqlite? ( dev-db/sqlite:3 )
	ssl? ( dev-libs/openssl:= )
	systemd? ( sys-apps/systemd:= )
	tslib? ( >=x11-libs/tslib-1.21 )
	udev? ( virtual/libudev:= )
	vulkan? ( dev-util/vulkan-headers )
	X? (
		x11-libs/libdrm
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		>=x11-libs/libxcb-1.12:=[xkb]
		>=x11-libs/libxkbcommon-0.5.0[X]
		x11-libs/xcb-util-image
		x11-libs/xcb-util-keysyms
		x11-libs/xcb-util-renderutil
		x11-libs/xcb-util-wm
	)
	zstd? ( app-arch/zstd:= )
	!<dev-qt/qttools-6.2.0:6
"

RDEPEND="
	${DEPEND}
	connman? ( net-misc/connman )
	networkmanager? ( net-misc/networkmanager )
	"

PDEPEND="
	doc? ( ~dev-qt/qtbase-doc-${PV} )
"

PATCHES=(
	"${FILESDIR}/qtcore-5.14.1-qmake-update-libdirs-order.patch"
	"${FILESDIR}/${PN}-6.4.2-no-debug-output.patch"
	"${FILESDIR}/CVE-2023-38197-qtbase-6.5.diff"
)

src_configure() {
	local mycmakeargs=(
		# installation paths
		-DCMAKE_INSTALL_PREFIX=${QT6_PREFIX}
		-DINSTALL_BINDIR=${QT6_BINDIR}
		-DINSTALL_INCLUDEDIR=${QT6_HEADERDIR}
		-DINSTALL_LIBDIR=${QT6_LIBDIR}
		-DINSTALL_ARCHDATADIR=${QT6_ARCHDATADIR}
		-DINSTALL_PLUGINSDIR=${QT6_PLUGINDIR}
		-DINSTALL_LIBEXECDIR=${QT6_LIBEXECDIR}
		-DINSTALL_QMLDIR=${QT6_QMLDIR}
		-DINSTALL_DATADIR=${QT6_DATADIR}
		-DINSTALL_DOCDIR=${QT6_DOCDIR}
		-DINSTALL_TRANSLATIONSDIR=${QT6_TRANSLATIONDIR}
		-DINSTALL_SYSCONFDIR=${QT6_SYSCONFDIR}
		-DINSTALL_MKSPECSDIR=${QT6_ARCHDATADIR}/mkspecs
		-DINSTALL_EXAMPLESDIR=${QT6_EXAMPLESDIR}
		-DINSTALL_TESTSDIR=${QT6_TESTSDIR}
		-DQT_FEATURE_androiddeployqt=OFF
		$(qt_feature concurrent)
		$(qt_feature dbus)
		$(qt_feature gui)
		$(qt_feature gui testlib)
		$(qt_feature icu)
		$(qt_feature network)
		$(qt_feature sql)
		$(qt_feature systemd journald)
		$(qt_feature udev libudev)
		$(qt_feature zstd)

		$(qt_feature gui freetype)
		$(qt_feature gui system_freetype)
		$(qt_feature gui harfbuzz)
		$(qt_feature gui system_harfbuzz)
		$(qt_feature gui fontconfig)

		-DFEATURE_separate_debug_info=OFF

		# precompiled headers can cause problems on hardened, so turn them off
		-DBUILD_WITH_PCH=OFF

		# link-time code generation is not something we want to enable by default
		-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=OFF

		# reduced relocations cause major breakage on at least arm and ppc, so
		# don't specify anything and let the configure figure out if they are
		# supported; see also https://bugreports.qt.io/browse/QTBUG-36129
		# and https://bugreports.qt.io/browse/QTBUG-86173
		-DFEATURE_reduce_relocations=OFF

		# use the system linker (gold will be selected automagically otherwise)
		-DFEATURE_use_gold_linker=$(tc-ld-is-gold && echo ON || echo OFF)

		# do not build with -Werror
		-DWARNINGS_ARE_ERRORS=OFF

		-DCMAKE_SKIP_INSTALL_RPATH=ON

		# build shared libraries
		-DBUILD_SHARED_LIBS=ON

		# prefer system libraries (only common hard deps here)
		-DFEATURE_system_zlib=ON
		-DFEATURE_pcre2=ON
		-DFEATURE_system_pcre2=ON
		-DFEATURE_doubleconversion=ON
		-DFEATURE_system_doubleconversion=ON

		# use pkg-config to detect include and library paths
		-DFEATURE_pkg_config=ON

		# always enable glib event loop support
		-DFEATURE_glib=ON

		-DFEATURE_syslog=OFF

		# typedef qreal to double (warning: changing this flag breaks the ABI)
		-DQT_COORD_TYPE=double

		# exclude examples and tests from default build
		-DQT_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DQT_BUILD_TESTS=OFF

		$(qt_feature xml)

		# kernel features
		-DFEATURE_renameat2=ON # needs Linux 3.16, bug 669994
		-DTEST_renameat2=ON # needs Linux 3.16, bug 669994
		-DFEATURE_getentropy=ON # needs Linux 3.17, bug 669994
		-DFEATURE_statx=ON # needs Linux 4.11, bug 672856
	)

	use icu || mycmakeargs+=( -DFEATURE_iconv=ON )
	use dbus && mycmakeargs+=( -DINPUT_dbus=linked )

	use gui && mycmakeargs+=(
		$(qt_feature accessibility accessibility_atspi_bridge)
		$(qt_feature egl)
		$(qt_feature eglfs)
		$(qt_feature eglfs eglfs_egldevice)
		$(qt_feature eglfs eglfs_gbm)
		$(qt_feature eglfs gbm)
		$(qt_feature eglfs kms)
		$(qt_feature evdev)
		$(qt_feature evdev mtdev)
		$(qt_feature gif)
		$(qt_feature ico)
		$(qt_feature jpeg)
		$(qt_feature opengl)
		$(qt_feature gles2-only opengles2)
		$(qt_feature libinput)
		$(qt_feature png)
		$(qt_feature tslib)
		$(qt_feature tuio tuiotouch)
		$(qt_feature vulkan)
		$(qt_feature widgets)
		$(qt_feature X xcb)
		$(qt_feature X xcb_xlib)
		# bug 672340
		$(qt_feature X system_xcb_xinput)

		# disabling accessibility is not recommended by upstream, as
		# it will break QStyle and may break other internal parts of Qt
		-DFEATURE_accessibility=ON
		-DFEATURE_directfb=OFF
		-DFEATURE_linuxfb=OFF
	)

	use widgets && mycmakeargs+=(
		$(qt_feature cups)
		$(qt_feature gtk gtk3)
	)

	if use libinput || use X; then
		mycmakeargs+=( -DFEATURE_xkbcommon=ON )
	fi

	use network && mycmakeargs+=(
		$(qt_feature brotli)
		$(qt_feature gssapi)
		$(qt_feature libproxy)
		$(qt_feature sctp)
		$(qt_feature ssl openssl)
		$(qt_feature vnc)

		-DINPUT_openssl=$(usex ssl linked no)

		# respect system proxies by default: it's the most natural
		# setting, and it'll become the new upstream default in 5.8
		-DFEATURE_system_proxies=ON
	)

	use sql && mycmakeargs+=(
		$(qt_feature freetds sql_tds)
		$(qt_feature mysql sql_mysql)
		$(qt_feature oci8 sql_oci)
		$(qt_feature odbc sql_odbc)
		$(qt_feature postgres sql_psql)
		$(qt_feature sqlite sql_sqlite)
		$(qt_feature sqlite system_sqlite)

		-DFEATURE_sql_db2=OFF
		-DFEATURE_sql_ibase=OFF
	)

	if tc-is-gcc; then
		mycmakeargs+=(
			-DQT_QMAKE_TARGET_MKSPEC="linux-g++"
		)
	elif tc-is-clang; then
		mycmakeargs+=(
			-DQT_QMAKE_TARGET_MKSPEC="linux-clang"
		)
	fi

	qt6-build_src_configure
}

src_install() {
	if use examples; then
		qt_install_example_sources examples
	fi

	qt6-build_src_install
}
