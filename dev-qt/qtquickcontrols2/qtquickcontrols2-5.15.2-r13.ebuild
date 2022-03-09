# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_COMMIT=d8d6b14b9907adbc6ce307d52be34aaa761a58fa
QT5_GENERATE_DOCS="true"
inherit qt5-build

DESCRIPTION="Set of next generation Qt Quick controls for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ppc64 ~riscv x86"
fi

IUSE="examples widgets"
REQUIRED_USE="examples? ( widgets )"

DEPEND="
	=dev-qt/qtcore-${QT5_PV}*
	=dev-qt/qtdeclarative-${QT5_PV}*
	=dev-qt/qtgui-${QT5_PV}*
	widgets? ( =dev-qt/qtwidgets-${QT5_PV}* )
	doc? ( =dev-qt/qdoc-${QT5_PV}*[qml] )
"
RDEPEND="${DEPEND}
	=dev-qt/qtgraphicaleffects-${QT5_PV}*
"

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples")
}

src_prepare() {
	qt_use_disable_mod widgets widgets \
		src/imports/platform/platform.pro

	qt5-build_src_prepare
}
