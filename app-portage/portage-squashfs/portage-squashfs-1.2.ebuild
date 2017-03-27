EAPI=2

inherit eutils linux-mod

DESCRIPTION="Portage tree inside aufs2/squashfs service"
HOMEPAGE=""

SRC_URI=""
LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	sys-fs/squashfs-tools
	|| (
		sys-fs/aufs2
		sys-fs/aufs3
	)
	"

DEPEND="${RDEPEND}"

S="${WORKDIR}"

pkg_setup() {
	linux-mod_pkg_setup

	ebegin "Checking for SquashFS support"
	linux_chkconfig_present SQUASHFS
	eend $?

	if [[ $? -ne 0 ]] ; then
		eerror "Please enable SquashFS support in your kernel config, found at:"
		eerror
		eerror "  File systems"
		eerror "    Miscellaneous filesystems"
		eerror "      [*] SquashFS 4.0 - Squashed file system support"
		eerror
		eerror "and recompile your kernel ..."
		die "SquashFS support not detected!"
	fi
}

src_install() {
        newinitd "${FILESDIR}"/portage-squashfs-init squash_portage || die
        newconfd "${FILESDIR}"/portage-squashfs-conf squash_portage || die
}
