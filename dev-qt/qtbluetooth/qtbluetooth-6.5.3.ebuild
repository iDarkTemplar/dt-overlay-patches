# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT6_MODULE="qtconnectivity"
inherit qt6-build

DESCRIPTION="Bluetooth support library for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~ppc64 ~riscv x86"
fi

IUSE=""

DEPEND="
	~dev-qt/qtbase-${PV}:6=[concurrent,dbus,network]
	>=net-wireless/bluez-5:=
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e 's/add_subdirectory(nfc)//' src/CMakeLists.txt || die

	qt6-build_src_prepare
}
