# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8
QT5_GENERATE_DOCS="true"
QT5_MODULE="qtlocation"
inherit qt5-build

DESCRIPTION="Physical position determination library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"
fi

IUSE="examples geoclue +qml"

RDEPEND="
	=dev-qt/qtcore-${QT5_PV}*
	doc? ( =dev-qt/qdoc-${QT5_PV}*[qml?] )
	geoclue? ( =dev-qt/qtdbus-${QT5_PV}* )
	qml? ( =dev-qt/qtdeclarative-${QT5_PV}* )
"
DEPEND="${RDEPEND}"
PDEPEND="
	geoclue? ( app-misc/geoclue:2.0 )
"

QT5_TARGET_SUBDIRS=(
	src/3rdparty/clipper
	src/3rdparty/poly2tri
	src/3rdparty/clip2tri
	src/positioning
	src/plugins/position/positionpoll
)

pkg_setup() {
	use geoclue && QT5_TARGET_SUBDIRS+=( src/plugins/position/geoclue2 )
	use qml && QT5_TARGET_SUBDIRS+=(
		src/positioningquick
		src/imports/positioning
	)

	use examples && QT5_EXAMPLES_SUBDIRS=("examples/positioning")
}

src_prepare() {
	qt_use_disable_mod qml quick \
		examples/positioning/positioning.pro

	qt5-build_src_prepare
}
