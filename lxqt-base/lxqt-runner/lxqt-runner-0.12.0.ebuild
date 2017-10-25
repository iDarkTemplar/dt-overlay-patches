# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit cmake-utils

DESCRIPTION="LXQt quick launcher"
HOMEPAGE="http://lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxde/${PN}.git"
else
	SRC_URI="https://github.com/lxde/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="GPL-2 LGPL-2.1+"
SLOT="0"

RDEPEND=">=dev-cpp/muParser-2.2.3
	dev-libs/glib:2
	>=dev-libs/libqtxdg-1.0.0:=
	dev-qt/qtcore:5=
	dev-qt/qtdbus:5=
	dev-qt/qtgui:5=
	dev-qt/qtwidgets:5=
	dev-qt/qtx11extras:5=
	dev-qt/qtxml:5=
	kde-frameworks/kwindowsystem:5=
	>=lxde-base/menu-cache-0.5.1
	~lxqt-base/liblxqt-${PV}
	~lxqt-base/lxqt-globalkeys-${PV}
	!lxqt-base/lxqt-common
"
DEPEND="${RDEPEND}
	>=dev-util/cmake-3.6.2
	>=dev-util/lxqt-build-tools-0.4.0
	dev-qt/linguist-tools:5=
	virtual/pkgconfig"

src_configure() {
	local mycmakeargs=( -DPULL_TRANSLATIONS=OFF )
	cmake-utils_src_configure
}

src_install(){
	cmake-utils_src_install
	doman man/*.1
}
