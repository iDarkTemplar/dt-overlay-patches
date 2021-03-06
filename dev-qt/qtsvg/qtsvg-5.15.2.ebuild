# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
QT5_GENERATE_DOCS="true"
inherit qt5-build

DESCRIPTION="SVG rendering library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~sparc x86"
fi

IUSE="examples"

RDEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtgui-${PV}
	~dev-qt/qtwidgets-${PV}
	examples? (
		~dev-qt/qtnetwork-${PV}
		~dev-qt/qtopengl-${PV}
	)
	sys-libs/zlib:=
"
DEPEND="${RDEPEND}
	test? ( ~dev-qt/qtxml-${PV} )
"

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples")
}
