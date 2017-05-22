# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Logrotate config files for portage"
HOMEPAGE="https://wiki.gentoo.org/wiki/Logrotate"

SRC_URI=""
LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND=""

S="${WORKDIR}"

INST_DIR="etc/logrotate.d"

src_install() {
	insinto "${INST_DIR}"
	doins "${FILESDIR}/portage-emerge-log"
}
