# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9,10,11} )
inherit cmake python-any-r1 qt6-build

DESCRIPTION="Library for rendering dynamic web content in Qt6 C++ and QML applications"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64"
fi

IUSE="alsa bindist designer doc examples geolocation kerberos pepper print pulseaudio +system-ffmpeg +system-icu"
REQUIRED_USE="print? ( pepper )"

BDEPEND="${PYTHON_DEPS}
	dev-util/gperf
	dev-util/ninja
	dev-util/re2c
	net-libs/nodejs[ssl]
	sys-devel/bison
	sys-devel/flex
	doc? ( ~dev-qt/qttools-${PV}:6=[qml] )
	"

RDEPEND="
	app-arch/snappy:=
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	dev-libs/expat
	dev-libs/libevent:=
	dev-libs/libxml2[icu]
	dev-libs/libxslt
	dev-libs/re2:=
	~dev-qt/qtbase-${PV}:6=[gui,network,widgets]
	~dev-qt/qtdeclarative-${PV}:6=[widgets]
	~dev-qt/qtwebchannel-${PV}:6=[qml]
	~dev-qt/qtwebsockets-${PV}:6=[qml]
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz:=
	media-libs/lcms:2
	media-libs/libjpeg-turbo:=
	media-libs/libpng:0=
	>=media-libs/libvpx-1.5:=[svc(+)]
	media-libs/libwebp:=
	media-libs/opus
	sys-apps/dbus
	sys-apps/pciutils
	sys-libs/zlib[minizip]
	virtual/libudev
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libxkbfile
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	alsa? ( media-libs/alsa-lib )
	designer? ( ~dev-qt/qttools-${PV}:6= )
	geolocation? ( ~dev-qt/qtlocation-${PV}:6= )
	kerberos? ( virtual/krb5 )
	pulseaudio? ( media-sound/pulseaudio:= )
	system-ffmpeg? ( media-video/ffmpeg:0= )
	system-icu? ( >=dev-libs/icu-69.1:= )
	doc? ( !dev-qt/qt-docs:6 )
"
DEPEND="${RDEPEND}
	media-libs/libglvnd
"
PDEPEND="
	examples? ( ~dev-qt/qtwebengine-examples-${PV} )
"

src_prepare() {
	qt_use_disable_target designer Qt::Designer \
		src/webenginewidgets/CMakeLists.txt

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs

	qt6_prepare_env

	# bug 633838
	unset QMAKESPEC XQMAKESPEC QMAKEPATH QMAKEFEATURES

	mycmakeargs=(
		-DQT_FEATURE_webengine_geolocation=$(usex geolocation ON OFF)
		-DQT_FEATURE_webengine_kerberos=$(usex kerberos ON OFF)
		-DQT_FEATURE_webengine_pepper_plugins=$(usex pepper ON OFF)
		-DQT_FEATURE_webengine_printing_and_pdf=$(usex print ON OFF)
		-DQT_FEATURE_webengine_proprietary_codecs=$(usex bindist OFF ON)
		-DQT_FEATURE_webengine_system_alsa=$(usex alsa ON OFF)
		-DQT_FEATURE_webengine_system_ffmpeg=$(usex system-ffmpeg ON OFF)
		-DQT_FEATURE_webengine_system_icu=$(usex system-icu ON OFF)
		-DQT_FEATURE_webengine_system_libevent=ON
		-DQT_FEATURE_webengine_system_pulseaudio=$(usex pulseaudio ON OFF)

		# exclude examples and tests from default build
		-DQT_BUILD_EXAMPLES=OFF
		-DQT_BUILD_TESTS=OFF
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc; then
		cmake_src_compile docs
	fi
}

src_install() {
	cmake_src_install $(usev doc install_docs)

	qt_install_bin_symlinks
}
