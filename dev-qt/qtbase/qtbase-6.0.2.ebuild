# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QT6_MODULE="qtbase"
inherit linux-info cmake qt6-build toolchain-funcs flag-o-matic

DESCRIPTION="Cross-platform application development framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

# Qt Modules
IUSE="+concurrent +dbus +gui +network +sql +opengl +widgets"
REQUIRED_USE="opengl? ( gui ) widgets? ( gui )"

QTGUI_IUSE="accessibility egl eglfs evdev +gif gles2-only +ico +jpeg libinput png tslib tuio vulkan +X"
QTNETWORK_IUSE="connman gssapi libproxy networkmanager sctp +ssl vnc"
QTSQL_IUSE="mysql oci8 odbc postgres +sqlite"
IUSE+=" ${QTGUI_IUSE} ${QTNETWORK_IUSE} ${QTSQL_IUSE} cups doc examples gtk icu old-kernel systemd +udev"

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
	sql? ( || ( mysql oci8 odbc postgres sqlite ) )
	X? ( gles2-only? ( egl ) )
"

BDEPEND="
	app-text/xmlstarlet
	"

DEPEND="
	app-arch/zstd:=
	dev-libs/double-conversion:=
	dev-libs/glib:2
	dev-libs/libpcre2[pcre16,unicode]
	media-libs/tiff:0
	sys-libs/zlib:=
	cups? ( >=net-print/cups-1.4 )
	dbus? ( >=sys-apps/dbus-1.4.20 )
	egl? ( media-libs/mesa[egl] )
	eglfs? (
		media-libs/mesa[gbm]
		x11-libs/libdrm
	)
	evdev? ( sys-libs/mtdev )
	gles2-only? ( media-libs/mesa[gles2] )
	!gles2-only? ( virtual/opengl )
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
	jpeg? ( virtual/jpeg:0 )
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
	sctp? ( kernel_linux? ( net-misc/lksctp-tools ) )
	sqlite? ( dev-db/sqlite:3 )
	ssl? ( dev-libs/openssl:0= )
	systemd? ( sys-apps/systemd:= )
	tslib? ( >=x11-libs/tslib-1.21 )
	udev? ( virtual/libudev:= )
	vulkan? ( dev-util/vulkan-headers )
	X? (
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
	"${FILESDIR}/qtcore-5.14.1-examples.patch"
	"${FILESDIR}/qtcore-5.14.1-qmake-update-libdirs-order.patch"
)

pkg_pretend() {
	use kernel_linux || return
	get_running_version
	if kernel_is -lt 4 11 && ! use old-kernel; then
		ewarn "The running kernel is older than 4.11. USE=old-kernel is needed for"
		ewarn "dev-qt/qtbase to function on this kernel properly. Bugs #669994, #672856"
	fi
}

src_configure() {
	local mycmakeargs

	# bug 633838
	unset QMAKESPEC XQMAKESPEC QMAKEPATH QMAKEFEATURES

	qt6_prepare_env

	mycmakeargs=(
		# installation paths
		-DCMAKE_INSTALL_PREFIX="${QT6_PREFIX}"
		-DINSTALL_BINDIR="${QT6_BINDIR}"
		-DINSTALL_INCLUDEDIR="${QT6_HEADERDIR}"
		-DINSTALL_LIBDIR="${QT6_LIBDIR}"
		-DINSTALL_ARCHDATADIR="${QT6_ARCHDATADIR}"
		-DINSTALL_PLUGINSDIR="${QT6_PLUGINDIR}"
		-DINSTALL_LIBEXECDIR="${QT6_LIBEXECDIR}"
		-DINSTALL_QMLDIR="${QT6_QMLDIR}"
		-DINSTALL_MKSPECSDIR="${QT6_MKSPECSDIR}"
		-DINSTALL_DATADIR="${QT6_DATADIR}"
		-DINSTALL_DOCDIR="${QT6_DOCDIR}"
		-DINSTALL_TRANSLATIONSDIR="${QT6_TRANSLATIONDIR}"
		-DINSTALL_SYSCONFDIR="${QT6_SYSCONFDIR}"
		-DINSTALL_EXAMPLESDIR="${QT6_EXAMPLESDIR}"
		-DINSTALL_TESTSDIR="${QT6_TESTSDIR}"

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

		-DFEATURE_journald=$(usex systemd ON OFF)
		-DFEATURE_libudev=$(usex udev ON OFF)
		-DFEATURE_syslog=OFF
		-DFEATURE_zstd=ON

		# typedef qreal to double (warning: changing this flag breaks the ABI)
		-DQT_COORD_TYPE=double

		# exclude examples and tests from default build
		-DQT_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DQT_BUILD_TESTS=OFF

		-DFEATURE_concurrent=$(usex concurrent ON OFF)
		-DFEATURE_dbus=$(usex dbus ON OFF)
		-DFEATURE_gui=$(usex gui ON OFF)
		-DFEATURE_icu=$(usex icu ON OFF)
		-DFEATURE_network=$(usex network ON OFF)
		-DFEATURE_sql=$(usex sql ON OFF)
		-DFEATURE_testlib=ON
		-DFEATURE_sql=$(usex sql ON OFF)
		-DFEATURE_xml=ON

		-DFEATURE_freetype=$(usex gui ON OFF)
		-DFEATURE_system_freetype=$(usex gui ON OFF)
		-DFEATURE_harfbuzz=$(usex gui ON OFF)
		-DFEATURE_system_harfbuzz=$(usex gui ON OFF)
		-DFEATURE_fontconfig=$(usex gui ON OFF)

		# kernel features
		-DFEATURE_renameat2=$(usex old-kernel OFF ON) # needs Linux 3.16, bug 669994
		-DFEATURE_getentropy=$(usex old-kernel OFF ON) # needs Linux 3.17, bug 669994
		-DFEATURE_statx=$(usex old-kernel OFF ON) # needs Linux 4.11, bug 672856
	)

	use icu || mycmakeargs+=( -DFEATURE_iconv=ON )
	use dbus && mycmakeargs+=( -DINPUT_dbus=linked )

	use gui && mycmakeargs+=(
		# disabling accessibility is not recommended by upstream, as
		# it will break QStyle and may break other internal parts of Qt
		-DFEATURE_accessibility=ON
		-DFEATURE_accessibility_atspi_bridge=$(usex accessibility ON OFF)
		-DFEATURE_directfb=OFF
		-DFEATURE_egl=$(usex egl ON OFF)
		-DFEATURE_eglfs=$(usex eglfs ON OFF)
		-DFEATURE_evdev=$(usex evdev ON OFF)
		-DFEATURE_gbm=$(usex eglfs ON OFF)
		-DFEATURE_gif=$(usex gif ON OFF)
		-DFEATURE_ico=$(usex ico ON OFF)
		-DFEATURE_jpeg=$(usex jpeg ON OFF)
		-DFEATURE_kms=$(usex eglfs ON OFF)
		-DFEATURE_libinput=$(usex libinput ON OFF)
		-DFEATURE_linuxfb=OFF
		-DFEATURE_mtdev=$(usex evdev ON OFF)
		-DFEATURE_opengl=$(usex opengl ON OFF)
		-DFEATURE_opengles2=$(usex gles2-only ON OFF)
		-DFEATURE_png=$(usex png ON OFF)
		-DFEATURE_tslib=$(usex tslib ON OFF)
		-DFEATURE_tuiotouch=$(usex tuio ON OFF)
		-DFEATURE_vulkan=$(usex vulkan ON OFF)
		-DFEATURE_widgets=$(usex widgets ON OFF)
		-DFEATURE_xcb=$(usex X ON OFF)
		-DFEATURE_xcb_xlib=$(usex X ON OFF)

		# bug 672340
		-DFEATURE_system_xcb_xinput=$(usex X ON OFF)
	)

	use widgets && mycmakeargs+=(
		-DFEATURE_cups=$(usex cups ON OFF)
		-DFEATURE_gtk3=$(usex gtk ON OFF)
	)

	if use libinput || use X; then
		mycmakeargs+=( -DFEATURE_xkbcommon=ON )
	fi

	use network && mycmakeargs+=(
		-DFEATURE_gssapi=$(usex gssapi ON OFF)
		-DFEATURE_libproxy=$(usex libproxy ON OFF)
		-DFEATURE_sctp=$(usex sctp ON OFF)
		-DFEATURE_ssl=$(usex ssl ON OFF)
		-DINPUT_openssl=$(usex ssl linked no)
		-DFEATURE_vnc=$(usex vnc ON OFF)

		# respect system proxies by default: it's the most natural
		# setting, and it'll become the new upstream default in 5.8
		-DFEATURE_system_proxies=ON
	)

	use sql && mycmakeargs+=(
		-DFEATURE_sql_db2=OFF
		-DFEATURE_sql_ibase=OFF
		-DFEATURE_sql_mysql=$(usex mysql ON OFF)
		-DFEATURE_sql_oci=$(usex oci8 ON OFF)
		-DFEATURE_sql_odbc=$(usex odbc ON OFF)
		-DFEATURE_sql_psql=$(usex postgres ON OFF)
		-DFEATURE_sql_sqlite=$(usex sqlite ON OFF)
		-DFEATURE_system_sqlite=$(usex sqlite ON OFF)
	)

	if use oci8; then
		append-flags "-I${ORACLE_HOME}/include"
		append-flags "-L${ORACLE_HOME}/$(get_libdir)"
	fi

	if tc-is-gcc; then
		mycmakeargs+=(
			-DQT_QMAKE_TARGET_MKSPEC="linux-g++"
		)
	elif tc-is-clang; then
		mycmakeargs+=(
			-DQT_QMAKE_TARGET_MKSPEC="linux-clang"
		)
	fi

	if is-flagq -mno-dsp || is-flagq -mno-dspr2 ; then
		mycmakeargs+=(
			-DFEATURE_mips_dsp=ON
		)
	else
		mycmakeargs+=(
			-DFEATURE_mips_dsp=OFF
		)
	fi

	cmake_src_configure
}

src_install() {
	local exampledir
	local installexampledir

	if use examples; then
		# QTBUG-86302: install example sources manually
		while read exampledir ; do
			exampledir="$(dirname "$exampledir")"
			installexampledir="$(dirname "$exampledir")"
			installexampledir="${installexampledir#examples/}"
			insinto "${QT6_EXAMPLESDIR}/${installexampledir}"
			doins -r "${exampledir}"
		done < <(find examples -name CMakeLists.txt 2>/dev/null | xargs grep -l -i project)
	fi

	cmake_src_install

	qt_install_bin_symlinks
}
