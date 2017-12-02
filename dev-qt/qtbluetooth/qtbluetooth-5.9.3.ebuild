# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE="qtconnectivity"
inherit qt5-build-multilib

DESCRIPTION="Bluetooth support library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

IUSE="examples qml"

RDEPEND="
	~dev-qt/qtconcurrent-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtdbus-${PV}[${MULTILIB_USEDEP}]
	>=net-wireless/bluez-5:=[${MULTILIB_USEDEP}]
	qml? ( ~dev-qt/qtdeclarative-${PV}[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	~dev-qt/qtnetwork-${PV}[${MULTILIB_USEDEP}]
"

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples/bluetooth")
}

src_prepare() {
	sed -i -e 's/nfc//' src/src.pro || die

	qt_use_disable_mod qml quick \
		src/src.pro \
		examples/bluetooth/bluetooth.pro

	qt5-build-multilib_src_prepare
}
