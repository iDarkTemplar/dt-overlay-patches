# Copyright 2007-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit ecm

DESCRIPTION="Open source media player built with Qt/QML and libmpv"
HOMEPAGE="https://apps.kde.org/haruna/"
SRC_URI="https://invent.kde.org/multimedia/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="youtube"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5=
	dev-qt/qtdeclarative:5
	dev-qt/qtquickcontrols2:5
	dev-qt/qtdbus:5
	dev-qt/qtx11extras:5
	media-video/mpv:=[libmpv(+)]
	media-video/ffmpeg:=
	kde-plasma/breeze
	kde-frameworks/kconfig
	kde-frameworks/kcoreaddons
	kde-frameworks/kdoctools
	kde-frameworks/kfilemetadata
	kde-frameworks/ki18n
	kde-frameworks/kiconthemes
	kde-frameworks/kio
	kde-frameworks/kirigami
	kde-frameworks/kconfigwidgets
	kde-frameworks/kwindowsystem
"
RDEPEND="${DEPEND}
	youtube? ( net-misc/yt-dlp )"

S="${WORKDIR}/${PN}-v${PV}"
