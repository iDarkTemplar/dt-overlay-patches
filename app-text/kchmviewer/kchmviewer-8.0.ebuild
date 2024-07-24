# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop qmake-utils xdg-utils

MY_PV="RELEASE_${PV/./_}"

DESCRIPTION="Feature rich chm file viewer, based on Qt"
HOMEPAGE="https://www.ulduzsoft.com/kchmviewer/"
SRC_URI="https://github.com/gyunaev/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	dev-libs/chmlib
	dev-libs/libzip:=
	dev-qt/qtbase:6[dbus,gui,network,xml,widgets]
	dev-qt/qt5compat:6
	dev-qt/qtwebengine:6[widgets]
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-upstream-fix-1.patch"
	"${FILESDIR}/${P}-upstream-fix-2.patch"
	"${FILESDIR}/${P}-upstream-fix-3.patch"
	"${FILESDIR}/${P}-disable-linkClicked-signal.patch"
	"${FILESDIR}/${P}-implement-opening-additional-windows.patch"
	"${FILESDIR}/${P}-synchronize-url-with-navigation-panel.patch"
	"${FILESDIR}/${P}-port-to-qt6.patch"
	"${FILESDIR}/${P}-remove-updates-check.patch"
	"${FILESDIR}/${P}-remove-whats-this-function.patch"
	"${FILESDIR}/${P}-remove-debug-output.patch"
	"${FILESDIR}/${P}-upstream-return-initialization.patch"
)

src_configure() {
	eqmake6
}

src_install() {
	dodoc ChangeLog DBUS-bindings FAQ README
	doicon packages/kchmviewer.png
	dobin bin/kchmviewer
	domenu packages/kchmviewer.desktop
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
