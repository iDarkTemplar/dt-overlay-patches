# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3

DESCRIPTION="findcruft2 is a tool to find orphaned files for unmerged packages"
HOMEPAGE="https://github.com/iDarkTemplar/findcruft2"

EGIT_REPO_URI="git://github.com/iDarkTemplar/findcruft2.git https://github.com/iDarkTemplar/findcruft2.git"
PROPERTIES="live"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	app-shells/bash
	sys-apps/grep
	sys-apps/coreutils
	sys-apps/findutils
	sys-apps/sed
"

src_install() {
	dosbin findcruft
	insinto /etc/findcruft
	doins -r etc/*
}
