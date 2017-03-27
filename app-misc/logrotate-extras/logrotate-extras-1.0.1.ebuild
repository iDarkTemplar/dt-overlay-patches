EAPI=4

inherit eutils

DESCRIPTION="Extra config files for logrotate"
HOMEPAGE=""

SRC_URI=""
LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+portage"

RDEPEND="app-admin/logrotate"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

INST_DIR="etc/logrotate.d"

REQUIRED_USE="portage"

src_install() {
	cd "${S}"

	mkdir -p "${D}/${INST_DIR}"

	if use portage; then
		cp "${FILESDIR}/portage-emerge-log" "${D}/${INST_DIR}/"
	fi
}
