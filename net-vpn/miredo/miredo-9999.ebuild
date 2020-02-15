# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils linux-info user

DESCRIPTION="Miredo is an open-source Teredo IPv6 tunneling software"
HOMEPAGE="http://www.remlab.net/miredo/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.remlab.net/git/miredo.git"
else
	SRC_URI="http://www.remlab.net/files/${PN}/${P}.tar.xz"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+caps nls"

RDEPEND="sys-apps/iproute2
	dev-libs/judy
	caps? ( sys-libs/libcap )
	nls? ( sys-devel/gettext )"
DEPEND="${RDEPEND}
	app-arch/xz-utils"

CONFIG_CHECK="~IPV6" #318777

#tries to connect to external networks (#339180)
RESTRICT="test"

DOCS=( AUTHORS ChangeLog.old NEWS README TODO THANKS )

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.2.5-configure-libcap.diff
	epatch "${FILESDIR}"/${PN}-1.2.5-ip-path.patch

	if [[ ${PV} == *9999 ]]; then
		./autogen.sh
	fi

	eautoreconf
	eapply_user
}

src_configure() {
	econf \
		--disable-static \
		--enable-miredo-user \
		--localstatedir=/var \
		--disable-rpath \
		$(use_with caps libcap) \
		$(use_enable nls)
}

src_install() {
	default
	prune_libtool_files

	newinitd "${FILESDIR}"/miredo.rc.2 miredo
	newconfd "${FILESDIR}"/miredo.conf.2 miredo
	newinitd "${FILESDIR}"/miredo.rc.2 miredo-server
	newconfd "${FILESDIR}"/miredo.conf.2 miredo-server

	insinto /etc/miredo
	doins misc/miredo-server.conf
}

pkg_preinst() {
	enewgroup miredo
	enewuser miredo -1 -1 /var/empty miredo
}
