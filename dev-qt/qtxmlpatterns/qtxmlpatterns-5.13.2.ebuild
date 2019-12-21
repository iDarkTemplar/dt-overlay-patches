# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit qt5-build

DESCRIPTION="XPath, XQuery, XSLT, and XML Schema validation library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm ~arm64 ~hppa ppc ppc64 ~sparc x86 ~amd64-fbsd"
fi

IUSE="examples qml"

DEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtnetwork-${PV}
	qml? ( ~dev-qt/qtdeclarative-${PV} )
	examples? ( ~dev-qt/qtwidgets-${PV} )
"
RDEPEND="${DEPEND}"

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples")
}

src_prepare() {
	qt_use_disable_mod qml qml \
		src/src.pro \
		src/imports/imports.pro

	qt_use_disable_mod qml quick tests/auto/auto.pro

	qt5-build_src_prepare
}
