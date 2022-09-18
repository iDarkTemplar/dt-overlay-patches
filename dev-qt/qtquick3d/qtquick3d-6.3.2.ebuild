# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build-extra

DESCRIPTION="Qt module and API for defining 3D content in Qt QuickTools"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE="doc examples"

BDEPEND="
	doc? ( ~dev-qt/qttools-${PV}:6=[qdoc(+),qtattributionsscanner(+)] )
	"

# TODO: reintroduce system assimp dependency when both qt3d and qtquick3d would build with system assimp

DEPEND="
	~dev-qt/qtbase-${PV}:6=
	~dev-qt/qtdeclarative-${PV}:6=
	~dev-qt/qtshadertools-${PV}:6=
	media-libs/assimp:=
	doc? ( !dev-qt/qt-docs:6 )
"

RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		# exclude examples and tests from default build
		-DQT_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DQT_BUILD_TESTS=OFF

		-DINPUT_quick3d_assimp=system
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

	cmake_src_install $(usev doc install_docs)

	qt_install_bin_symlinks
}
