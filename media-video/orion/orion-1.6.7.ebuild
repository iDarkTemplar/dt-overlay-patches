# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit desktop qmake-utils xdg

DESCRIPTION="Cross-platform Twitch client"
HOMEPAGE="https://alamminsalo.github.io/orion/"
SRC_URI="https://github.com/alamminsalo/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+mpv qtav qtmedia"

DEPEND="
	>=dev-qt/qtquickcontrols2-5.8:5
	>=dev-qt/qtgraphicaleffects-5.8:5
	>=dev-qt/qtdeclarative-5.8:5
	>=dev-qt/qtgui-5.8:5
	>=dev-qt/qtwidgets-5.8:5
	>=dev-qt/qtnetwork-5.8:5
	>=dev-qt/qtdbus-5.8:5
	mpv? ( media-video/mpv[libmpv] )
	qtav? ( media-libs/qtav )
	qtmedia? ( >=dev-qt/qtmultimedia-5.8:5 )"
RDEPEND="${DEPEND}
	!mpv? ( media-plugins/gst-plugins-hls )"

REQUIRED_USE="^^ ( mpv qtav qtmedia )"

PATCHES=(
	"${FILESDIR}"/${P}-fix-crash-at-exit.patch
	"${FILESDIR}"/${P}-simplify-and-uniformize-singleton-initialization.patch
	"${FILESDIR}"/${P}-dont-use-broken-font.patch
	"${FILESDIR}"/${P}-change-default-view.patch
	"${FILESDIR}"/${P}-revert-topbar-hiding-at-screen-edge.patch
	"${FILESDIR}"/${P}-hide-headers-only-in-player-view.patch
)

src_configure() {
	local PLAYER
	if use mpv; then
		PLAYER=mpv
	elif use qtav; then
		PLAYER=qtav
	else
		PLAYER=multimedia
	fi
	eqmake5 ${PN}.pro CONFIG+=${PLAYER}
}

src_install() {
	dobin ${PN}
	domenu distfiles/*.desktop

	insinto /usr/share/icons/hicolor/scalable/apps
	doins distfiles/${PN}.svg
}
