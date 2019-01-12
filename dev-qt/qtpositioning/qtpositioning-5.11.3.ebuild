# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE="qtlocation"
inherit qt5-build-multilib

DESCRIPTION="Physical position determination library for the Qt5 framework"
SRC_URI+=" https://dev.gentoo.org/~asturm/distfiles/${QT5_MODULE}-${PV}-geoclue2.tar.xz"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 x86"
fi

IUSE="examples geoclue +qml"

RDEPEND="
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	geoclue? ( ~dev-qt/qtdbus-${PV}[${MULTILIB_USEDEP}] )
	qml? ( ~dev-qt/qtdeclarative-${PV}[${MULTILIB_USEDEP}] )
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
	sed -i -e "/qtHaveModule/s/geoclue/geoclue2/" src/plugins/position/position.pro || die

	qt_use_disable_mod qml quick \
		examples/positioning/positioning.pro

	qt5-build-multilib_src_prepare
}
