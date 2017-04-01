EAPI=5

inherit eutils

DESCRIPTION="A script for combining parts of multiple git repositories"
HOMEPAGE="https://github.com/iDarkTemplar/dt-patches-mixer"

SRC_URI="https://github.com/iDarkTemplar/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-fbsd ~x86-fbsd"
IUSE="+portage"

DEPEND="
	"

RDEPEND="
	$DEPEND
	dev-vcs/git
	"

src_install() {
	cd "${S}"

	dobin "${S}/dt-patches-mixer"

	insinto /etc
	doins "${S}/dt-patches-mixer.conf"

	if use portage ; then
		exeinto "/etc/portage/postsync.d"
		doexe "${S}/dt-patches-mixer-sync"
	fi
}
