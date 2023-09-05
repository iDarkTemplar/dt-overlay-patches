# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build-extra

DESCRIPTION="Customizable input framework and virtual keyboard for Qt"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ppc64 x86"
fi

# TODO: unbudle libraries for more layouts
IUSE="doc examples handwriting +spell +X"

BDEPEND="
	doc? ( ~dev-qt/qttools-${PV}:6=[qdoc(+),qtattributionsscanner(+)] )
	"

DEPEND="
	~dev-qt/qtbase-${PV}:6=[gui]
	~dev-qt/qtdeclarative-${PV}:6=
	~dev-qt/qtsvg-${PV}:6=
	spell? ( app-text/hunspell:= )
	X? ( x11-libs/libxcb:= )
	doc? ( !dev-qt/qt-docs:6 )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		# exclude examples and tests from default build
		-DQT_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DQT_BUILD_TESTS=OFF

		-DINPUT_vkb_hunspell=$(usex spell system no)
		-DINPUT_vkb_handwriting=$(usex handwriting t9write no)
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
