# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils xdg-utils

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

DESCRIPTION="Fast lightweight tabbed filemanager (Qt port)"
HOMEPAGE="https://wiki.lxde.org/en/PCManFM"

LICENSE="GPL-2+"
SLOT="0"
IUSE="doc"

CDEPEND=">=dev-libs/glib-2.18:2
	dev-qt/qtcore:5=
	dev-qt/qtdbus:5=
	dev-qt/qtgui:5=
	dev-qt/qtwidgets:5=
	dev-qt/qtx11extras:5=
	>=x11-libs/libfm-1.2.0:=
	>=x11-libs/libfm-qt-0.13.0:=
	x11-libs/libxcb:=
"
RDEPEND="${CDEPEND}
	x11-misc/xdg-utils
	virtual/eject
	virtual/freedesktop-icon-theme"
DEPEND="${CDEPEND}
	dev-qt/linguist-tools:5=
	>=dev-util/lxqt-build-tools-0.5.0
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

src_configure() {
	local mycmakeargs=(
		-DPULL_TRANSLATIONS=NO
		-DBUILD_DOCUMENTATION=$(usex doc)
	)

	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
}
