# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
QT5_GENERATE_DOCS="true"
inherit qt5-build

DESCRIPTION="Set of Qt Quick controls to create complete user interfaces (deprecated)"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 x86"
fi

IUSE="examples +widgets"
REQUIRED_USE="examples? ( widgets )"

DEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtdeclarative-${PV}
	~dev-qt/qtgui-${PV}
	widgets? ( ~dev-qt/qtwidgets-${PV} )
	doc? ( ~dev-qt/qdoc-${PV}[qml] )
	examples? (
		~dev-qt/qtnetwork-${PV}
		~dev-qt/qtsql-${PV}
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

	qt5-build_src_prepare
}
