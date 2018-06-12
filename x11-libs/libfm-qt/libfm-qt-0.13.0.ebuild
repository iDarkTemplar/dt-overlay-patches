# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils xdg-utils

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

DESCRIPTION="Qt port of libfm, a library providing components to build desktop file managers"
HOMEPAGE="http://lxqt.org/"

LICENSE="LGPL-2.1+"
SLOT="0/5"
IUSE="doc"

RDEPEND="
	dev-libs/glib:2
	dev-qt/qtcore:5=
	dev-qt/qtgui:5=
	dev-qt/qtwidgets:5=
	dev-qt/qtx11extras:5=
	>=lxde-base/menu-cache-0.4.1
	media-libs/libexif
	>=x11-libs/libfm-1.2.0:=
	x11-libs/libxcb:=
	!<x11-misc/pcmanfm-qt-0.11.0
"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5=
	>=dev-util/lxqt-build-tools-0.5.0
	lxqt-base/liblxqt
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

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
