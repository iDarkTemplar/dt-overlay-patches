EAPI=4

inherit eutils

DESCRIPTION="Extra syntax highlight files for Nano text editor"
HOMEPAGE=""

SRC_URI=""
LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+makeconf"

RDEPEND="app-editors/nano"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

INST_DIR="usr/share/nano"

REQUIRED_USE="makeconf"

src_install() {
	cd "${S}"

	mkdir -p "${D}/${INST_DIR}"

	if use makeconf; then
		cp "${FILESDIR}/makeconf.nanorc" "${D}/${INST_DIR}/"
	fi
}
