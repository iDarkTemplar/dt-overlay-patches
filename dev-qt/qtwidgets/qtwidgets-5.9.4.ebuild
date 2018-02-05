# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE="qtbase"
inherit qt5-build-multilib

DESCRIPTION="Set of components for creating classic desktop-style UIs for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
fi

# keep IUSE defaults in sync with qtgui
IUSE="examples gles2 gtk +png +xcb"

DEPEND="
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[gles2=,png=,xcb?,${MULTILIB_USEDEP}]
	gtk? (
		x11-libs/gtk+:3[${MULTILIB_USEDEP}]
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/pango[${MULTILIB_USEDEP}]
	)
"
RDEPEND="${DEPEND}"

PDEPEND="
	examples? (
		~dev-qt/qtbase-examples-${PV}[gles2=]
	)
"

QT5_TARGET_SUBDIRS=(
	src/tools/uic
	src/widgets
	src/plugins/platformthemes
)

QT5_GENTOO_CONFIG=(
	gtk:gtk3:
	!:no-widgets:
)

QT5_GENTOO_PRIVATE_CONFIG=(
	:widgets
)

multilib_src_configure() {
	local myconf=(
		-opengl $(usex gles2 es2 desktop)
		$(qt_use gtk)
		-gui
		$(qt_use png libpng system)
		-widgets
		$(qt_use xcb xcb system)
		$(qt_use xcb xkbcommon system)
		$(usex xcb '-xcb-xlib -xinput2 -xkb' '')
	)
	qt5_multilib_src_configure
}
