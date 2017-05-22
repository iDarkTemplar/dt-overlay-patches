# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Extra config files for logrotate"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"

SRC_URI=""
LICENSE="freedist"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+portage"

REQUIRED_USE="portage"

RDEPEND=""
DEPEND="portage? ( app-misc/logrotate-extras-portage )"
