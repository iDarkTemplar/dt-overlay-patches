# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_COMMIT=e7883bc64440b1ff4666272ac6eb710ee4bc221b
QT5_GENERATE_DOCS="true"
inherit qt5-build

DESCRIPTION="Implementation of the WebSocket protocol for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"
fi

IUSE="examples qml +ssl"

DEPEND="
	=dev-qt/qtcore-${QT5_PV}*
	=dev-qt/qtnetwork-${QT5_PV}*[ssl=]
	qml? ( =dev-qt/qtdeclarative-${QT5_PV}* )
	doc? ( =dev-qt/qdoc-${QT5_PV}*[qml?] )
"
RDEPEND="${DEPEND}"

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples")
}

src_prepare() {
	qt_use_disable_mod qml quick \
		src/src.pro \
		examples/websockets/websockets.pro

	qt5-build_src_prepare
}
