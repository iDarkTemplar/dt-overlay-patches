# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Extra config files for logrotate"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"

SRC_URI=""
LICENSE="freedist"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+portage +sddm"

REQUIRED_USE="|| ( portage sddm )"

RDEPEND=""
DEPEND="portage? ( app-misc/logrotate-extras-portage )"

S="${WORKDIR}"

INST_DIR="etc/logrotate.d"

src_install() {
	insinto "${INST_DIR}"
	doins "${FILESDIR}/sddm"
}
