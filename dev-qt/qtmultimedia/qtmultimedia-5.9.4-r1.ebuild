# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qt5-build-multilib

DESCRIPTION="Multimedia (audio, video, radio, camera) library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
fi

IUSE="alsa examples gles2 gstreamer openal pulseaudio qml widgets"
REQUIRED_USE="examples? ( widgets )"

RDEPEND="
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[gles2=,${MULTILIB_USEDEP}]
	~dev-qt/qtnetwork-${PV}[${MULTILIB_USEDEP}]
	alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
	gstreamer? (
		dev-libs/glib:2[${MULTILIB_USEDEP}]
		media-libs/gstreamer:1.0[${MULTILIB_USEDEP}]
		media-libs/gst-plugins-bad:1.0[${MULTILIB_USEDEP}]
		media-libs/gst-plugins-base:1.0[${MULTILIB_USEDEP}]
	)
	pulseaudio? ( media-sound/pulseaudio[${MULTILIB_USEDEP}] )
	qml? (
		~dev-qt/qtdeclarative-${PV}[${MULTILIB_USEDEP}]
		gles2? ( ~dev-qt/qtgui-${PV}[egl,${MULTILIB_USEDEP}] )
		openal? ( media-libs/openal[${MULTILIB_USEDEP}] )
	)
	widgets? (
		~dev-qt/qtopengl-${PV}[${MULTILIB_USEDEP}]
		~dev-qt/qtwidgets-${PV}[gles2=,${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	gstreamer? ( x11-proto/videoproto[${MULTILIB_USEDEP}] )
"

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples")
}

src_prepare() {
	# bug 646756
	sed -i -e '/CONFIG\s*+=/ s/optimize_full//' \
		src/multimedia/multimedia.pro || die

	qt_use_disable_config openal openal \
		src/imports/imports.pro

	qt_use_disable_mod qml quick \
		src/src.pro \
		src/plugins/plugins.pro \
		examples/multimedia/multimedia.pro

	qt_use_disable_mod widgets widgets \
		src/src.pro \
		src/gsttools/gsttools.pro \
		src/plugins/gstreamer/common.pri \
		examples/multimedia/multimedia.pro \
		examples/multimediawidgets/multimediawidgets.pro

	qt5-build-multilib_src_prepare
}

multilib_src_configure() {
	local myqmakeargs=(
		--
		$(qt_use alsa)
		$(qt_use gstreamer)
		$(qt_use pulseaudio)
	)
	qt5_multilib_src_configure
}
