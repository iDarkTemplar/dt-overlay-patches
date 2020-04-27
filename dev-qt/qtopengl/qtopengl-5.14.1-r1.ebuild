# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
QT5_MODULE="qtbase"
VIRTUALX_REQUIRED="test"
inherit qt5-build

DESCRIPTION="OpenGL support library for the Qt5 framework (deprecated)"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm arm64 ~hppa ppc ppc64 ~sparc x86"
fi

IUSE="doc examples gles2-only"

DEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtgui-${PV}[gles2-only=]
	~dev-qt/qtwidgets-${PV}[gles2-only=]
	virtual/opengl
"
RDEPEND="${DEPEND}"

PDEPEND="
	doc? (
		~dev-qt/qtbase-doc-${PV}[gles2-only=]
	)
	examples? (
		~dev-qt/qtbase-examples-${PV}[gles2-only=]
	)
"

QT5_TARGET_SUBDIRS=(
	src/opengl
)

src_configure() {
	local myconf=(
		-opengl $(usex gles2-only es2 desktop)
	)
	qt5-build_src_configure
}