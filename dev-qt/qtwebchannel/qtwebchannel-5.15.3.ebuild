# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT5_KDEPATCHSET_REV=1
QT5_GENERATE_DOCS="true"
inherit qt5-build

DESCRIPTION="Qt5 module for integrating C++ and QML applications with HTML/JavaScript clients"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~ppc ppc64 ~riscv x86"
fi

IUSE="examples qml"
REQUIRED_USE="examples? ( qml )"

DEPEND="
	=dev-qt/qtcore-${QT5_PV}*
	qml? ( =dev-qt/qtdeclarative-${QT5_PV}* )
	doc? ( =dev-qt/qdoc-${QT5_PV}*[qml?] )
	examples? (
		=dev-qt/qtwidgets-${QT5_PV}*
		=dev-qt/qtwebsockets-${QT5_PV}*
	)
"
RDEPEND="${DEPEND}"

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples")
}

src_prepare() {
	qt_use_disable_mod qml quick src/src.pro
	qt_use_disable_mod qml qml src/webchannel/webchannel.pro

	qt5-build_src_prepare
}
