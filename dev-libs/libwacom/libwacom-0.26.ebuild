# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils udev multilib-minimal

DESCRIPTION="Library for identifying Wacom tablets and their model-specific features"
HOMEPAGE="http://linuxwacom.sourceforge.net/"
SRC_URI="mirror://sourceforge/linuxwacom/${PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc static-libs"

RDEPEND="
	dev-libs/glib:2[${MULTILIB_USEDEP}]
	virtual/libgudev:=[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_prepare() {
	default
	if ! use doc; then
		sed -e 's:^\(SUBDIRS = .* \)doc:\1:' -i Makefile.in || die
	fi
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf $(use_enable static-libs static)
}

multilib_src_install() {
	default

	if multilib_is_native_abi; then
		local udevdir="$(get_udevdir)"
		dodir "${udevdir}/rules.d"
		# generate-udev-rules must be run from inside tools directory
		pushd tools > /dev/null || die
		./generate-udev-rules > "${ED}/${udevdir}/rules.d/65-libwacom.rules" || die "generating udev rules failed"
		popd > /dev/null || die
	fi

	prune_libtool_files
}

multilib_src_install_all() {
	use doc && dohtml -r doc/html/*
}
