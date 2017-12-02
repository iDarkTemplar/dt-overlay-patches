# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit multiprocessing pax-utils python-any-r1 qt5-build-multilib

DESCRIPTION="Library for rendering dynamic web content in Qt5 C++ and QML applications"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS=""
fi

IUSE="alsa bindist examples geolocation pax_kernel pulseaudio +system-ffmpeg +system-icu widgets"
REQUIRED_USE="examples? ( widgets )"

RDEPEND="
	app-arch/snappy:=[${MULTILIB_USEDEP}]
	dev-libs/glib:2[${MULTILIB_USEDEP}]
	dev-libs/nspr[${MULTILIB_USEDEP}]
	dev-libs/nss[${MULTILIB_USEDEP}]
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtdeclarative-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtnetwork-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtprintsupport-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtwebchannel-${PV}[qml,${MULTILIB_USEDEP}]
	dev-libs/expat[${MULTILIB_USEDEP}]
	dev-libs/libevent:=[${MULTILIB_USEDEP}]
	dev-libs/libxml2[${MULTILIB_USEDEP}]
	dev-libs/libxslt[${MULTILIB_USEDEP}]
	dev-libs/protobuf:=[${MULTILIB_USEDEP}]
	media-libs/fontconfig[${MULTILIB_USEDEP}]
	media-libs/freetype[${MULTILIB_USEDEP}]
	media-libs/harfbuzz:=[${MULTILIB_USEDEP}]
	media-libs/libpng:0=[${MULTILIB_USEDEP}]
	>=media-libs/libvpx-1.5:=[svc,${MULTILIB_USEDEP}]
	media-libs/libwebp:=[${MULTILIB_USEDEP}]
	media-libs/mesa[${MULTILIB_USEDEP}]
	media-libs/opus[${MULTILIB_USEDEP}]
	net-libs/libsrtp:0=[${MULTILIB_USEDEP}]
	sys-apps/dbus[${MULTILIB_USEDEP}]
	sys-apps/pciutils[${MULTILIB_USEDEP}]
	sys-libs/libcap[${MULTILIB_USEDEP}]
	sys-libs/zlib[minizip,${MULTILIB_USEDEP}]
	virtual/jpeg:0[${MULTILIB_USEDEP}]
	virtual/libudev[${MULTILIB_USEDEP}]
	x11-libs/libdrm[${MULTILIB_USEDEP}]
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libXcomposite[${MULTILIB_USEDEP}]
	x11-libs/libXcursor[${MULTILIB_USEDEP}]
	x11-libs/libXdamage[${MULTILIB_USEDEP}]
	x11-libs/libXext[${MULTILIB_USEDEP}]
	x11-libs/libXfixes[${MULTILIB_USEDEP}]
	x11-libs/libXi[${MULTILIB_USEDEP}]
	x11-libs/libXrandr[${MULTILIB_USEDEP}]
	x11-libs/libXrender[${MULTILIB_USEDEP}]
	x11-libs/libXScrnSaver[${MULTILIB_USEDEP}]
	x11-libs/libXtst[${MULTILIB_USEDEP}]
	alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
	geolocation? ( ~dev-qt/qtpositioning-${PV}[${MULTILIB_USEDEP}] )
	pulseaudio? ( media-sound/pulseaudio:=[${MULTILIB_USEDEP}] )
	system-ffmpeg? ( media-video/ffmpeg:0=[${MULTILIB_USEDEP}] )
	system-icu? ( dev-libs/icu:=[${MULTILIB_USEDEP}] )
	widgets? ( ~dev-qt/qtwidgets-${PV}[${MULTILIB_USEDEP}] )
	examples? (
		~dev-qt/qtquickcontrols2-${PV}[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=app-arch/gzip-1.7
	dev-util/gperf
	dev-util/ninja
	dev-util/re2c
	sys-devel/bison
	pax_kernel? ( sys-apps/elfix )
"

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples")
}

src_prepare() {
	use pax_kernel && PATCHES+=( "${FILESDIR}/${PN}-5.9.0-paxmark-mksnapshot.patch" )

	# bug 620444 - ensure local headers are used
	find "${S}" -type f -name "*.pr[fio]" | xargs sed -i -e 's|INCLUDEPATH += |&$$QTWEBENGINE_ROOT/include |' || die

	qt_use_disable_config alsa alsa src/core/config/linux.pri
	qt_use_disable_config pulseaudio pulseaudio src/core/config/linux.pri

	qt_use_disable_mod geolocation positioning \
		mkspecs/features/configure.prf \
		src/core/core_chromium.pri \
		src/core/core_common.pri

	qt_use_disable_mod widgets widgets src/src.pro

	qt5-build-multilib_src_prepare
}

multilib_src_configure() {
	export NINJA_PATH=/usr/bin/ninja
	export NINJAFLAGS="${NINJAFLAGS:--j$(makeopts_jobs) -l$(makeopts_loadavg "${MAKEOPTS}" 0) -v}"

	local myqmakeargs=(
		$(usex bindist '' 'WEBENGINE_CONFIG+=use_proprietary_codecs')
		$(usex system-ffmpeg 'WEBENGINE_CONFIG+=use_system_ffmpeg' '')
		$(usex system-icu 'WEBENGINE_CONFIG+=use_system_icu' '')
	)
	qt5_multilib_src_configure
}

multilib_src_install() {
	qt5_multilib_src_install

	# bug 601472
	if [[ ! -f ${D%/}${QT5_LIBDIR}/libQt5WebEngine.so ]]; then
		die "${CATEGORY}/${PF} failed to build anything. Please report to https://bugs.gentoo.org/"
	fi

	pax-mark m "${D%/}${QT5_LIBEXECDIR}"/QtWebEngineProcess
}
