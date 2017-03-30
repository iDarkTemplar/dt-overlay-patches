EAPI=5

inherit eutils cmake-utils

DESCRIPTION="Utility to remove leftover files of linux kernels"
HOMEPAGE="https://github.com/iDarkTemplar/dt-kernel-cleaner"

SRC_URI="https://github.com/iDarkTemplar/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	dev-libs/boost
	"

RDEPEND="
	$DEPEND
	"

src_configure() {
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}
