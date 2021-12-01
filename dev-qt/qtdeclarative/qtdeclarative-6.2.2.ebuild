# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake qt6-build

DESCRIPTION="The QML and Quick modules for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE="doc examples gles2-only +jit localstorage vulkan +widgets"

DEPEND="
	~dev-qt/qtbase-${PV}:6=[gui,gles2-only=,network,vulkan=,widgets=]
	~dev-qt/qtshadertools-${PV}:6
	localstorage? ( ~dev-qt/qtbase-${PV}:6=[sql] )
	!dev-qt/qtquickcontrols2:6
"

RDEPEND="${DEPEND}"

PDEPEND="
	doc? ( ~dev-qt/qtdeclarative-doc-${PV} )
	examples? ( ~dev-qt/qtdeclarative-examples-${PV} )
"

src_prepare() {
	qt_use_disable_target localstorage Qt::Sql \
		src/imports/CMakeLists.txt \
		tests/auto/qml/CMakeLists.txt

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs

	qt6_prepare_env

	# bug 633838
	unset QMAKESPEC XQMAKESPEC QMAKEPATH QMAKEFEATURES

	mycmakeargs=(
		# exclude examples and tests from default build
		-DQT_BUILD_EXAMPLES=OFF
		-DQT_BUILD_TESTS=OFF
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	qt_install_bin_symlinks
}
