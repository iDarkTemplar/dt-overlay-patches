EAPI=4

inherit eutils

DESCRIPTION="Additional skins for QMMP"
HOMEPAGE="http://qmmp.ylsoftware.com"

SRC_URI="http://qmmp.ylsoftware.com/files/skins/Skins_All_in_One.zip"
LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND="media-sound/qmmp"

S="${WORKDIR}"

INST_DIR="usr/share/qmmp/skins"
ZIP_DIR="Skins_All_in_One"

src_install() {
	cd "${S}"

	insinto "${EPREFIX}/${INST_DIR}"
	doins "${S}/${ZIP_DIR}"/*
}
