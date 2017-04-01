EAPI=5

inherit eutils cmake-utils

DESCRIPTION="Mail filter based on libmilter allowing to run custom lua scripts to filter the email"
HOMEPAGE="https://github.com/iDarkTemplar/dt-lua-milter"

SRC_URI="https://github.com/iDarkTemplar/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-fbsd ~x86-fbsd"
IUSE="+openrc"

DEPEND="
	mail-filter/libmilter
	dev-lang/lua
	"

RDEPEND="
	$DEPEND
	"

src_configure() {
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use openrc ; then
		newinitd "${S}/openrc/dt-lua-milter.service" "dt-lua-milter"
		newconfd "${S}/openrc/dt-lua-milter.conf" "dt-lua-milter"
	fi
}
