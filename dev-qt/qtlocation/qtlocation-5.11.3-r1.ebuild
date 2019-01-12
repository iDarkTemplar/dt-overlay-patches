# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qt5-build-multilib

DESCRIPTION="The Location module for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

IUSE="examples"

RDEPEND="
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtdeclarative-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtnetwork-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtpositioning-${PV}[qml,${MULTILIB_USEDEP}]
	~dev-qt/qtsql-${PV}[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	~dev-qt/qtconcurrent-${PV}[${MULTILIB_USEDEP}]
"

QT5_TARGET_SUBDIRS=(
	src/3rdparty/clipper
	src/3rdparty/poly2tri
	src/3rdparty/clip2tri
	src/3rdparty/mapbox-gl-native
	src/location
	src/imports/location
	src/plugins/geoservices
)

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples/location")
}

multilib_src_configure() {
	# src/plugins/geoservices requires files that are only generated when
	# qmake is run in the root directory. Bug 633776.
	mkdir -p "${QT5_BUILD_DIR}" || die
	qt5_qmake "${QT_BUILD_DIR}"
	qt5_multilib_src_configure
}
