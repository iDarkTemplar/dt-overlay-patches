# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE="qtbase"
VIRTUALX_REQUIRED="test"
inherit qt5-build-multilib

DESCRIPTION="Printing support library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
fi

IUSE="cups gles2"

RDEPEND="
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[gles2=,${MULTILIB_USEDEP}]
	~dev-qt/qtwidgets-${PV}[gles2=,${MULTILIB_USEDEP}]
	cups? ( >=net-print/cups-1.4[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	test? ( ~dev-qt/qtnetwork-${PV}[${MULTILIB_USEDEP}] )
"

QT5_TARGET_SUBDIRS=(
	src/printsupport
	src/plugins/printsupport
)

QT5_GENTOO_CONFIG=(
	cups
)

multilib_src_configure() {
	local myconf=(
		$(qt_use cups)
		-opengl $(usex gles2 es2 desktop)
	)
	qt5_multilib_src_configure
}
