# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build-extra

DESCRIPTION="Wayland platform plugin for Qt"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE="doc examples vulkan X"

BDEPEND="
	dev-util/wayland-scanner
	doc? ( ~dev-qt/qttools-${PV}:6=[qdoc(+),qtattributionsscanner(+)] )
	"

DEPEND="
	dev-libs/wayland
	~dev-qt/qtbase-${PV}:6=[gui,egl,opengl,vulkan=,X=]
	~dev-qt/qtdeclarative-${PV}:6=
	media-libs/libglvnd
	x11-libs/libxkbcommon
	vulkan? ( dev-util/vulkan-headers )
	X? (
		~dev-qt/qtbase-${PV}:6=[-gles2-only]
		x11-libs/libX11
		x11-libs/libXcomposite
	)
	doc? ( !dev-qt/qt-docs:6 )
"

RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		# exclude examples and tests from default build
		-DQT_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DQT_BUILD_TESTS=OFF
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
