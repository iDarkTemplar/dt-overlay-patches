# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build-extra

DESCRIPTION="Qt Multimedia"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"
fi

IUSE="alsa doc examples +ffmpeg gstreamer pulseaudio qml widgets"
REQUIRED_USE="examples? ( widgets )"

BDEPEND="
	doc? ( ~dev-qt/qttools-${PV}:6=[qdoc(+),qtattributionsscanner(+)] )
	"

RDEPEND="
	~dev-qt/qtbase-${PV}:6=[concurrent,gui,network,widgets?]
	~dev-qt/qtshadertools-${PV}:6
	alsa? ( media-libs/alsa-lib )
	ffmpeg? ( media-video/ffmpeg:= )
	gstreamer? (
		dev-libs/glib:2
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-bad:1.0
		media-libs/gst-plugins-base:1.0
	)
	pulseaudio? ( media-libs/libpulse[glib] )
	qml? (
		~dev-qt/qtdeclarative-${PV}:6=
	)
	widgets? (
		media-libs/libglvnd
	)
	doc? ( !dev-qt/qt-docs:6 )
"
DEPEND="${RDEPEND}
	gstreamer? ( x11-base/xorg-proto )
	"

PATCHES=(
	"${FILESDIR}/${PN}-6.5.1-examples-build.patch"
)

src_prepare() {
	qt_use_disable_target qml Qt::Quick \
		src/CMakeLists.txt \
		src/plugins/CMakeLists.txt \
		examples/multimedia/CMakeLists.txt

	qt_use_disable_target widgets Qt::Widgets \
		src/CMakeLists.txt \
		examples/multimedia/CMakeLists.txt \
		examples/multimediawidgets/CMakeLists.txt

	qt6-build_src_prepare
}

src_configure() {
	local mycmakeargs=(
		# exclude examples and tests from default build
		-DQT_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DQT_BUILD_TESTS=OFF

		-DQT_FEATURE_alsa=$(usex alsa ON OFF)
		-DQT_FEATURE_ffmpeg=$(usex ffmpeg ON OFF)
		-DQT_FEATURE_gstreamer=$(usex gstreamer ON OFF)
		-DQT_FEATURE_pulseaudio=$(usex pulseaudio ON OFF)
	)

	qt6-build_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc; then
		cmake_src_compile docs
	fi
}

src_install() {
	if use examples; then
		qt_install_example_sources examples
	fi

	qt6-build_src_install

	if use doc; then
		qt_install_docs
	fi
}
