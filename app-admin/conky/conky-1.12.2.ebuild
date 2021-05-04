# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake linux-info readme.gentoo-r1 xdg

DESCRIPTION="An advanced, highly configurable system monitor for X"
HOMEPAGE="https://github.com/brndnmtthws/conky"
SRC_URI="https://github.com/brndnmtthws/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 BSD LGPL-2.1 MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ppc ppc64 sparc x86"
IUSE="apcupsd audacious bundled-toluapp cmus curl doc hddtemp ical iconv imlib iostats
	ipv6 irc lua-cairo lua-imlib lua-rsvg math moc mpd mysql nano-syntax
	ncurses nvidia +portmon pulseaudio rss systemd thinkpad truetype
	vim-syntax weather-metar webserver wifi X xinerama xmms2"

COMMON_DEPEND="
	audacious? ( media-sound/audacious )
	cmus? ( media-sound/cmus )
	curl? ( net-misc/curl )
	ical? ( dev-libs/libical:= )
	iconv? ( virtual/libiconv )
	imlib? ( media-libs/imlib2[X] )
	irc? ( net-libs/libircclient )
	lua-cairo? ( x11-libs/cairo[X] )
	lua-imlib? ( media-libs/imlib2[X] )
	lua-rsvg? ( gnome-base/librsvg )
	mysql? ( dev-db/mysql-connector-c )
	ncurses? ( sys-libs/ncurses:= )
	nvidia? ( x11-drivers/nvidia-drivers[tools,static-libs] )
	pulseaudio? ( media-sound/pulseaudio )
	rss? ( dev-libs/libxml2 net-misc/curl dev-libs/glib:2 )
	systemd? ( sys-apps/systemd )
	truetype? ( x11-libs/libXft >=media-libs/freetype-2 )
	wifi? ( net-wireless/wireless-tools )
	weather-metar? ( net-misc/curl )
	webserver? ( net-libs/libmicrohttpd )
	X? (
		x11-libs/libX11
		x11-libs/libXdamage
		x11-libs/libXfixes
		x11-libs/libXext
	)
	xinerama? ( x11-libs/libXinerama )
	xmms2? ( media-sound/xmms2 )
	|| ( dev-lang/lua:5.4 dev-lang/lua:5.3 dev-lang/lua:5.2 )
"
RDEPEND="
	${COMMON_DEPEND}
	apcupsd? ( sys-power/apcupsd )
	hddtemp? ( app-admin/hddtemp )
	moc? ( media-sound/moc )
	nano-syntax? ( app-editors/nano )
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )
"
DEPEND="
	${COMMON_DEPEND}
	doc? ( app-text/docbook2X dev-libs/libxslt )
"

REQUIRED_USE="
	imlib? ( X )
	lua-cairo? ( X  bundled-toluapp )
	lua-imlib? ( X  bundled-toluapp )
	lua-rsvg? ( X  bundled-toluapp )
	nvidia? ( X )
	truetype? ( X )
	xinerama? ( X )
"

CONFIG_CHECK="~IPV6"

DOCS=( README.md AUTHORS )

PATCHES=(
	"${FILESDIR}"/${PN}-1.12.1-network-speed.patch
	"${FILESDIR}"/${PN}-1.11.5-lua-5.4.patch
)

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="You can find sample configurations at ${ROOT}/usr/share/doc/${PF}.
To customize, copy to \${XDG_CONFIG_HOME}/conky/conky.conf
and edit it to your liking.

There are pretty html docs available at the conky homepage
or in ${ROOT}/usr/share/doc/${PF}/html when built with USE=doc.

Also see https://wiki.gentoo.org/wiki/Conky/HOWTO"

pkg_setup() {
	use ipv6 && linux-info_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	xdg_environment_reset

	sed -i -e "s|find_program(APP_MAN man)|set(APP_MAN $(which man) CACHE FILEPATH MAN_BINARY)|" \
		cmake/ConkyPlatformChecks.cmake || die
}

src_configure() {
	local mycmakeargs

	if use X; then
		mycmakeargs=(
			-DBUILD_ARGB=yes
			-DBUILD_X11=yes
			-DBUILD_XDAMAGE=yes
			-DBUILD_XDBE=yes
			-DBUILD_XSHAPE=yes
			-DOWN_WINDOW=yes
		)
	else
		mycmakeargs=(
			-DBUILD_X11=no
		)
	fi

	mycmakeargs+=(
		-DBUILD_APCUPSD=$(usex apcupsd)
		-DBUILD_AUDACIOUS=$(usex audacious)
		-DBUILD_BUILTIN_CONFIG=yes
		-DBUILD_CMUS=$(usex cmus)
		-DBUILD_CURL=$(usex curl)
		-DBUILD_DOCS=$(usex doc)
		-DBUILD_HDDTEMP=$(usex hddtemp)
		-DBUILD_HTTP=$(usex webserver)
		-DBUILD_I18N=yes
		-DBUILD_IBM=$(usex thinkpad)
		-DBUILD_ICAL=$(usex ical)
		-DBUILD_ICONV=$(usex iconv)
		-DBUILD_IMLIB2=$(usex imlib)
		-DBUILD_IOSTATS=$(usex iostats)
		-DBUILD_IPV6=$(usex ipv6)
		-DBUILD_IRC=$(usex irc)
		-DBUILD_JOURNAL=$(usex systemd)
		-DBUILD_LUA_CAIRO=$(usex lua-cairo)
		-DBUILD_LUA_IMLIB2=$(usex lua-imlib)
		-DBUILD_LUA_RSVG=$(usex lua-rsvg)
		-DBUILD_MATH=$(usex math)
		-DBUILD_MOC=$(usex moc)
		-DBUILD_MPD=$(usex mpd)
		-DBUILD_MYSQL=$(usex mysql)
		-DBUILD_NCURSES=$(usex ncurses)
		-DBUILD_NVIDIA=$(usex nvidia)
		-DBUILD_OLD_CONFIG=yes
		-DBUILD_PORT_MONITORS=$(usex portmon)
		-DBUILD_PULSEAUDIO=$(usex pulseaudio)
		-DBUILD_RSS=$(usex rss)
		-DBUILD_WEATHER_METAR=$(usex weather-metar)
		-DBUILD_WLAN=$(usex wifi)
		-DBUILD_XFT=$(usex truetype)
		-DBUILD_XINERAMA=$(usex xinerama)
		-DBUILD_XMMS2=$(usex xmms2)
		-DDOC_PATH=/usr/share/doc/${PF}
		-DMAINTAINER_MODE=no
		-DRELEASE=yes
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/ftdetect
		doins "${S}"/extras/vim/ftdetect/conkyrc.vim

		insinto /usr/share/vim/vimfiles/syntax
		doins "${S}"/extras/vim/syntax/conkyrc.vim
	fi

	if use nano-syntax; then
		insinto /usr/share/nano/
		doins "${S}"/extras/nano/conky.nanorc
	fi

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog

	xdg_pkg_postinst
}