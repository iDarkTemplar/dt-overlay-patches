# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qt5-build-multilib

DESCRIPTION="Set of controls used in conjunction with Qt Quick to build complete interfaces"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 x86"
fi

IUSE="examples +widgets"
REQUIRED_USE="examples? ( widgets )"

DEPEND="
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtdeclarative-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[${MULTILIB_USEDEP}]
	widgets? ( ~dev-qt/qtwidgets-${PV}[${MULTILIB_USEDEP}] )
	examples? (
		~dev-qt/qtnetwork-${PV}[${MULTILIB_USEDEP}]
		~dev-qt/qtsql-${PV}[${MULTILIB_USEDEP}]
	)
"
RDEPEND="${DEPEND}"

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples")
}

src_prepare() {
	qt_use_disable_mod widgets widgets \
		src/src.pro \
		src/controls/Private/private.pri \
		tests/auto/activeFocusOnTab/activeFocusOnTab.pro \
		tests/auto/controls/controls.pro \
		tests/auto/testplugin/testplugin.pro

	qt5-build-multilib_src_prepare
}
