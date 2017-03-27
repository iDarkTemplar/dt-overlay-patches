EAPI="2"

DESCRIPTION="ipfw.ru fortunes"
HOMEPAGE="http://ipfw.ru/"
DL_FILE="http://ipfw.ru/bash/fortune"

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

DEPEND="games-misc/fortune-mod
	app-i18n/enca
	net-misc/wget
	sys-apps/sed"

RDEPEND="games-misc/fortune-mod"

S=${WORKDIR}

src_prepare() {
	wget ${DL_FILE}
}

src_compile() {
	if [ \"`enca -i fortune`\" != \"UTF-8\" ]; then
		iconv -f \"`enca -i fortune `\" -t \"UTF-8\" < fortune > encoded
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
