# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Linux.org.ru fortunes"
HOMEPAGE="http://www.lorquotes.ru/"
DL_FILE="http://www.lorquotes.ru/fortraw.php"

LICENSE="freedist"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

DEPEND="games-misc/fortune-mod
	app-i18n/enca
	net-misc/wget"

RDEPEND="games-misc/fortune-mod"

S=${WORKDIR}

src_unpack() {
	wget ${DL_FILE} || die
}

src_compile() {
	if [ \"$(enca -i fortraw.php)\" != \"UTF-8\" ]; then
		iconv -f \"$(enca -i fortraw.php)\" -t \"UTF-8\" < fortraw.php > encoded.php
		rm fortraw.php
		mv encoded.php fortraw.php
	fi

	strfile fortraw.php
}

src_install() {
	insinto /usr/share/fortune
	newins fortraw.php lorquotes.ru || die
	newins fortraw.php.dat lorquotes.ru.dat || die
}
