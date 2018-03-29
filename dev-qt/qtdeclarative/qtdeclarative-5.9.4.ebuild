# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} )
inherit python-any-r1 qt5-build-multilib

DESCRIPTION="The QML and Quick modules for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ppc ppc64 x86"
fi

IUSE="examples gles2 +jit localstorage +widgets xml"

REQUIRED_USE="examples? ( widgets )"

# qtgui[gles2=] is needed because of bug 504322
COMMON_DEPEND="
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[gles2=,${MULTILIB_USEDEP}]
	~dev-qt/qtnetwork-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qttest-${PV}[${MULTILIB_USEDEP}]
	localstorage? ( ~dev-qt/qtsql-${PV}[${MULTILIB_USEDEP}] )
	widgets? ( ~dev-qt/qtwidgets-${PV}[gles2=,${MULTILIB_USEDEP}] )
	xml? (
		~dev-qt/qtnetwork-${PV}[${MULTILIB_USEDEP}]
		~dev-qt/qtxmlpatterns-${PV}[${MULTILIB_USEDEP}]
	)
	examples? (
		~dev-qt/qtnetwork-${PV}[${MULTILIB_USEDEP}]
	)
"
DEPEND="${COMMON_DEPEND}
	${PYTHON_DEPS}
"
RDEPEND="${COMMON_DEPEND}
	!<dev-qt/qtquickcontrols-5.7:5
"

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples")
}

src_prepare() {
	use jit || PATCHES+=("${FILESDIR}/${PN}-5.4.2-disable-jit.patch")

	qt_use_disable_mod localstorage sql \
		src/imports/imports.pro

	qt_use_disable_mod widgets widgets \
		src/src.pro \
		src/qmltest/qmltest.pro \
		tests/auto/auto.pro \
		tools/tools.pro \
		tools/qmlscene/qmlscene.pro \
		tools/qml/qml.pro \
		examples/quick/quick.pro

	qt_use_disable_mod xml xmlpatterns \
		src/imports/imports.pro \
		tests/auto/quick/quick.pro \
		tests/auto/quick/examples/examples.pro

	qt5-build-multilib_src_prepare
}
