# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Make.conf syntax highlight files for Nano text editor"
HOMEPAGE="http://gentoo-en.vfose.ru/wiki/Nano_syntax_highlighting"

SRC_URI=""
LICENSE="FDL-1.2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND=""

S="${WORKDIR}"

INST_DIR="usr/share/nano"

src_install() {
	insinto "${INST_DIR}"
	doins "${FILESDIR}/makeconf.nanorc"
}
