# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE="qtbase"
VIRTUALX_REQUIRED="test"
inherit qt5-build-multilib

DESCRIPTION="OpenGL support library for the Qt5 framework (deprecated)"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
fi

IUSE="examples gles2"

DEPEND="
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[gles2=,${MULTILIB_USEDEP}]
	~dev-qt/qtwidgets-${PV}[gles2=,${MULTILIB_USEDEP}]
	virtual/opengl[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

PDEPEND="
	examples? (
		~dev-qt/qtbase-examples-${PV}[gles2=]
	)
"

QT5_TARGET_SUBDIRS=(
	src/opengl
)

multilib_src_configure() {
	local myconf=(
		-opengl $(usex gles2 es2 desktop)
	)
	qt5_multilib_src_configure
}
