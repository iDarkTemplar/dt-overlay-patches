# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake qt6-build

DESCRIPTION="Multimedia (audio, video, radio, camera) library for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"
fi

IUSE="alsa doc examples gles2-only gstreamer pulseaudio qml widgets"
REQUIRED_USE="examples? ( widgets )"

BDEPEND="
	doc? ( ~dev-qt/qttools-${PV}:6=[qml?] )
	"

RDEPEND="
	~dev-qt/qtbase-${PV}:6=[concurrent,gui,network,gles2-only?]
	~dev-qt/qtshadertools-${PV}:6
	alsa? ( media-libs/alsa-lib )
	gstreamer? (
		dev-libs/glib:2
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-bad:1.0
		media-libs/gst-plugins-base:1.0
	)
	pulseaudio? ( media-sound/pulseaudio[glib] )
	qml? (
		~dev-qt/qtdeclarative-${PV}:6=
		gles2-only? ( ~dev-qt/qtbase-${PV}:6=[egl] )
	)
	widgets? (
		~dev-qt/qtbase-${PV}:6=[widgets]
		media-libs/libglvnd
	)
	doc? ( !dev-qt/qt-docs:6 )
"
DEPEND="${RDEPEND}
	gstreamer? ( x11-base/xorg-proto )
	"

PATCHES=(
	"${FILESDIR}/${PN}-6.2.0-alsa.patch"
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

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs

	qt6_prepare_env

	# bug 633838
	unset QMAKESPEC XQMAKESPEC QMAKEPATH QMAKEFEATURES

	mycmakeargs=(
		-DQT_FEATURE_alsa=$(usex alsa ON OFF)
		-DQT_FEATURE_pulseaudio=$(usex pulseaudio ON OFF)

		# exclude examples and tests from default build
		-DQT_BUILD_EXAMPLES=$(usex examples ON OFF)
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

	cmake_src_install $(usev doc install_docs)

	qt_install_bin_symlinks
}
