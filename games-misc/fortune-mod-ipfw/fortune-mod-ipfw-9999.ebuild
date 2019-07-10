# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="ipfw.ru fortunes"
HOMEPAGE="http://ipfw.ru/"
DL_FILE="http://ipfw.ru/bash/fortune"

LICENSE="freedist"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

DEPEND="games-misc/fortune-mod
	app-i18n/enca
	net-misc/wget
	sys-apps/sed"

RDEPEND="games-misc/fortune-mod"

S="${WORKDIR}"

src_unpack() {
	wget ${DL_FILE} || die
}

src_compile() {
	if [ \"$(enca -i fortune)\" != \"UTF-8\" ]; then
		iconv -f \"$(enca -i fortune)\" -t \"UTF-8\" < fortune > encoded
		rm fortune
		mv encoded fortune
	fi

	sed -i '/^$/d' fortune

	strfile fortune
}

src_install() {
	insinto /usr/share/fortune
	newins fortune ipfw.ru || die
	newins fortune.dat ipfw.ru.dat || die
}
