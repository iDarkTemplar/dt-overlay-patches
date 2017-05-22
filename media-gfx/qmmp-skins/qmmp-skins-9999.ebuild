# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Additional skins for QMMP"
HOMEPAGE="http://qmmp.ylsoftware.com"

SRC_URI="http://qmmp.ylsoftware.com/files/skins/Skins_All_in_One.zip"
LICENSE="freedist"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND="media-sound/qmmp"

S="${WORKDIR}"

INST_DIR="usr/share/qmmp/skins"
ZIP_DIR="Skins_All_in_One"

src_install() {
	insinto "${INST_DIR}"
	doins "${ZIP_DIR}"/*
}
