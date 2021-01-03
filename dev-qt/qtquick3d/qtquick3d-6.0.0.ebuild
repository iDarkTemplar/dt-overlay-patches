# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QT6_MODULE="qtquick3d"
inherit cmake qt6-build

DESCRIPTION="Qt Quick3D Libraries"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE="doc examples"
# TODO: example sources

BDEPEND="
	doc? ( ~dev-qt/qttools-${PV}:6=[qml] )
	"

DEPEND="
	>=media-libs/assimp-5.0.0
	~dev-qt/qtbase-${PV}:6=
	~dev-qt/qtdeclarative-${PV}:6=
	~dev-qt/qtshadertools-${PV}:6=
	!dev-qt/qt-docs
"

src_configure() {
	local mycmakeargs

	qt6_prepare_env

	# bug 633838
	unset QMAKESPEC XQMAKESPEC QMAKEPATH QMAKEFEATURES

	mycmakeargs=(
		# exclude examples and tests from default build
		-DQT_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DQT_BUILD_TESTS=OFF

		-DINPUT_quick3d_assimp=system
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
	cmake_src_install $(usex doc install_docs "")

	qt_install_bin_symlinks
}
