# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
QT5_GENERATE_DOCS="true"
QT5_MODULE="qtconnectivity"
inherit qt5-build

DESCRIPTION="Bluetooth support library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 x86"
fi

IUSE="examples qml"

RDEPEND="
	~dev-qt/qtconcurrent-${PV}
	~dev-qt/qtcore-${PV}:5=
	~dev-qt/qtdbus-${PV}
	>=net-wireless/bluez-5:=
	doc? ( ~dev-qt/qdoc-${PV}[qml?] )
	qml? ( ~dev-qt/qtdeclarative-${PV} )
"
DEPEND="${RDEPEND}
	~dev-qt/qtnetwork-${PV}
"

PATCHES=( "${FILESDIR}/${P}-gcc11.patch" ) # bug 752012

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples/bluetooth")
}

src_prepare() {
	sed -i -e 's/nfc//' src/src.pro || die

	qt_use_disable_mod qml quick \
		src/src.pro \
		examples/bluetooth/bluetooth.pro

	qt5-build_src_prepare
}
