# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build-extra

DESCRIPTION="Hardware sensor access library for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ~ppc ppc64 ~riscv ~sparc x86"
fi

# TODO: simulator
IUSE="doc examples qml"

BDEPEND="
	doc? ( ~dev-qt/qttools-${PV}:6=[qdoc(+),qtattributionsscanner(+)] )
	"

DEPEND="
	~dev-qt/qtbase-${PV}:6=[dbus]
	qml? ( ~dev-qt/qtdeclarative-${PV}:6= )
	doc? ( !dev-qt/qt-docs:6 )
	examples? (
		~dev-qt/qtbase-${PV}:6=[gui,widgets]
		~dev-qt/qtsvg-${PV}:6=
	)
"
RDEPEND="${DEPEND}"

src_prepare() {
	qt_use_disable_target qml Qt::Quick \
		src/CMakeLists.txt \
		examples/sensors/CMakeLists.txt

	qt6-build_src_prepare
}

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
