# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT6_MODULE="qtdeclarative"
inherit cmake qt6-build

DESCRIPTION="The QML and Quick modules for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE="examples gles2-only +jit localstorage vulkan +widgets"

BDEPEND="
	~dev-qt/qttools-${PV}:6=[qml]
	"

DEPEND="
	~dev-qt/qtdeclarative-${PV}:6=[examples=,gles2-only=,jit=,localstorage=,vulkan=,widgets=]
	!dev-qt/qt-docs:6
	!dev-qt/qtquickcontrols2:6
"

RDEPEND="${DEPEND}"

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
		-DQT_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DQT_BUILD_TESTS=OFF
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile docs
}

src_install() {
	DESTDIR="${D}" cmake_src_compile install_docs
}
