# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT6_MODULE="qtconnectivity"
inherit qt6-build-extra

DESCRIPTION="Bluetooth support library for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~ppc64 ~riscv x86"
fi

IUSE="doc examples"

BDEPEND="
	doc? ( ~dev-qt/qttools-${PV}:6=[qdoc(+),qtattributionsscanner(+)] )
	"

DEPEND="
	~dev-qt/qtbase-${PV}:6=[concurrent,dbus,network]
	>=net-wireless/bluez-5:=
	doc? ( !dev-qt/qt-docs:6 )
	examples? (
		~dev-qt/qtbase-${PV}:6=[gui,widgets]
		~dev-qt/qtdeclarative-${PV}:6=
	)
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e 's/add_subdirectory(nfc)//' src/CMakeLists.txt || die

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
		qt_install_example_sources examples/bluetooth examples
	fi

	cmake_src_install $(usev doc install_docs)

	qt_install_bin_symlinks
}
