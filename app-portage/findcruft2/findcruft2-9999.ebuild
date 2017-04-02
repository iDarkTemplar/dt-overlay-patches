# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit git-2

DESCRIPTION="findcruft2 is a tool to find orphaned files for unmerged packages"
HOMEPAGE="https://github.com/hollow/findcruft2"
EGIT_REPO_URI="git://github.com/hollow/findcruft2.git https://github.com/hollow/findcruft2.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="userland_GNU userland_BSD"

DEPEND=""
RDEPEND="
	app-shells/bash
	sys-apps/grep

	userland_GNU? (
		sys-apps/coreutils
		sys-apps/findutils
		sys-apps/sed
	)

	userland_BSD? (
		sys-freebsd/freebsd-bin
		sys-freebsd/freebsd-ubin
		sys-freebsd/freebsd-contrib
	)
"

src_install() {
	dosbin findcruft
	insinto /etc/findcruft
	doins -r etc/*
}
