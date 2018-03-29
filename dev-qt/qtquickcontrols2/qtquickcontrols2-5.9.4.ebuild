# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qt5-build-multilib

DESCRIPTION="Set of next generation Qt Quick controls for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

IUSE="examples widgets"
REQUIRED_USE="examples? ( widgets )"

DEPEND="
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtdeclarative-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[${MULTILIB_USEDEP}]
	widgets? ( ~dev-qt/qtwidgets-${PV}[${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}
	~dev-qt/qtgraphicaleffects-${PV}[${MULTILIB_USEDEP}]
"

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples")
}

src_prepare() {
	qt_use_disable_mod widgets widgets \
		src/imports/platform/platform.pro

	qt5-build-multilib_src_prepare
}
