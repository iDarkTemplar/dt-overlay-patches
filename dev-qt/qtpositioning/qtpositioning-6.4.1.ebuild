# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build-extra

DESCRIPTION="Physical position determination library for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~riscv x86"
fi

IUSE="doc examples geoclue nmea"

BDEPEND="
	doc? ( ~dev-qt/qttools-${PV}:6=[qdoc(+),qtattributionsscanner(+)] )
	"

DEPEND="
	~dev-qt/qtbase-${PV}:6=[concurrent,icu,sql]
	~dev-qt/qtdeclarative-${PV}:6=
	sys-libs/zlib
	geoclue? (
		~dev-qt/qtbase-${PV}:6=[dbus]
	)
	nmea? (
		~dev-qt/qtbase-${PV}:6=[network]
		~dev-qt/qtserialport-${PV}:6=
	)
	doc? ( !dev-qt/qt-docs:6 )
	examples? ( ~dev-qt/qtbase-${PV}:6=[gui,network] )
"
RDEPEND="${DEPEND}"

PDEPEND="
	geoclue? ( app-misc/geoclue:2.0 )
"

src_prepare() {
	qt_use_disable_target nmea Qt::SerialPort \
		src/plugins/position/CMakeLists.txt

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

	cmake_src_install $(usev doc install_docs)

	qt_install_bin_symlinks
}