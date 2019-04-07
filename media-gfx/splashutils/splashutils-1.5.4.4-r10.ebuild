# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils multilib toolchain-funcs

MISCSPLASH="miscsplashutils-0.1.8"
GENTOOSPLASH="splashutils-gentoo-1.0.17"

RESTRICT="test"
IUSE="+png +truetype +mng gpm fbcondecor"

DESCRIPTION="Framebuffer splash utilities"
HOMEPAGE="https://sourceforge.net/projects/fbsplash.berlios/"
SRC_URI="
	mirror://sourceforge/fbsplash.berlios/${PN}-lite-${PV}.tar.bz2
	mirror://sourceforge/fbsplash.berlios/${GENTOOSPLASH}.tar.bz2
	mirror://gentoo/${MISCSPLASH}.tar.bz2
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"

RDEPEND="
	gpm? ( sys-libs/gpm )
	truetype? (
		>=media-libs/freetype-2
		app-arch/bzip2
		sys-libs/zlib
	)
	png? (
		>=media-libs/libpng-1.4.3
		sys-libs/zlib
	)
	mng? (
		media-libs/libmng
	)
	virtual/jpeg:0

	app-arch/cpio
	app-misc/pax-utils
	media-gfx/fbgrab
	!sys-apps/lcdsplash
	sys-apps/openrc"

DEPEND="${RDEPEND}
	virtual/pkgconfig
"

S="${WORKDIR}/${P/_/-}"
SG="${WORKDIR}/${GENTOOSPLASH}"
SM="${WORKDIR}/${MISCSPLASH}"

src_prepare() {
	cd "${SG}"
	epatch "${FILESDIR}/splashutils-1.5.4.4-gentoo-typo-fix.patch"
	epatch "${FILESDIR}/splashutils-1.5.4.4-sys-queue.patch"

	if use truetype ; then
		cd "${SM}"
		epatch "${FILESDIR}/splashutils-1.5.4.4-freetype-bz2.patch"
		epatch "${FILESDIR}/splashutils-1.5.4.4-no-static-fbtruetype.patch"
		cd "${WORKDIR}"
		epatch "${FILESDIR}/splashutils-1.5.4.4-ft25.patch"
	fi

	cd "${S}"
	ln -sf "${S}/src" "${WORKDIR}/core"

	epatch "${FILESDIR}/${P}-multi-keyboard.patch"
	epatch "${FILESDIR}/libmng2-lcms2.patch"
	# Bug #557126
	epatch "${FILESDIR}/${P}-no-la.patch"
	epatch "${FILESDIR}/splashutils-1.5.4.4-copy-anim-files.patch"
	epatch "${FILESDIR}/splashutils-1.5.4.4-sysmacros.patch"
	epatch "${FILESDIR}/${P}-system-libs.patch"
	epatch "${FILESDIR}/${P}-stop-draw-thread.patch"
	epatch "${FILESDIR}/${P}-no-static-in-filenames.patch"
	epatch "${FILESDIR}/${P}-fix-crash-and-memleak.patch"
	epatch "${FILESDIR}/${P}-fix-return-type-errors.patch"

	if ! use truetype ; then
		sed -i -e 's/fbtruetype kbd/kbd/' "${SM}/Makefile"
	fi

	sed -i -e 's:#!/sbin/runscript:#!/sbin/openrc-run:' "${SG}/init-fbcondecor"

	rm -f m4/*
	eapply_user
	eautoreconf
}

src_configure() {
	tc-export CC
	cd "${SM}"
	emake CC="${CC}" LIB=$(get_libdir) STRIP=true

	cd "${S}"
	econf \
		$(use_with png) \
		$(use_with mng) \
		$(use_with gpm) \
		$(use_with truetype ttf) \
		$(use_with truetype ttf-kernel) \
		$(use_enable fbcondecor) \
		--without-klibc \
		--docdir=/usr/share/doc/${PF} \
		--with-essential-libdir=/$(get_libdir)
}

src_compile() {
	emake CC="${CC}" STRIP="true"

	cd "${SG}"
	emake LIB=$(get_libdir)
}

src_install() {
	local LIB=$(get_libdir)

	cd "${SM}"
	emake DESTDIR="${D}" LIB=${LIB} install

	cd "${S}"
	emake DESTDIR="${D}" STRIP="true" install

	mv "${D}"/usr/${LIB}/libfbsplash.so* "${D}"/${LIB}/
	gen_usr_ldscript libfbsplash.so

	echo 'CONFIG_PROTECT_MASK="/etc/splash"' > 99splash
	doenvd 99splash

	if use fbcondecor ; then
		newinitd "${SG}"/init-fbcondecor fbcondecor
		newconfd "${SG}"/fbcondecor.conf fbcondecor
	fi
	newconfd "${SG}"/splash.conf splash

	insinto /usr/share/${PN}
	doins "${SG}"/initrd.splash

	insinto /etc/splash
	doins "${SM}"/fbtruetype/luxisri.ttf

	cd "${SG}"
	make DESTDIR="${D}" LIB=${LIB} install
	prune_libtool_files

	sed -i -e "s#/lib/splash#/${LIB}/splash#" "${D}"/sbin/splash-functions.sh
	keepdir /${LIB}/splash/{tmp,cache,bin,sys}
	dosym /${LIB}/splash/bin/fbres /sbin/fbres
}

pkg_preinst() {
	has_version "<${CATEGORY}/${PN}-1.0"
	previous_less_than_1_0=$?

	has_version "<${CATEGORY}/${PN}-1.5.3"
	previous_less_than_1_5_3=$?
}

pkg_postinst() {
	if has_version sys-fs/devfsd || ! has_version virtual/udev ; then
		elog "This package has been designed with udev in mind. Other solutions, such as"
		elog "devfs or a static /dev tree might work, but are generally discouraged and"
		elog "not supported. If you decide to switch to udev, you might want to have a"
		elog "look at 'The Gentoo udev Guide', which can be found at"
		elog "  https://wiki.gentoo.org/wiki/Udev"
		elog ""
	fi

	if [[ $previous_less_than_1_0 = 0 ]] ; then
		elog "Since you are upgrading from a pre-1.0 version, please make sure that you"
		elog "rebuild your initrds. You can use the splash_geninitramfs script to do that."
		elog ""
	fi

	if [[ $previous_less_than_1_5_3 = 0 ]] && ! use fbcondecor ; then
		elog "Starting with splashutils-1.5.3, support for the fbcondecor kernel patch"
		elog "is optional and dependent on the the 'fbcondecor' USE flag.  If you wish"
		elog "to use fbcondecor, run:"
		elog "  echo \"media-gfx/splashutils fbcondecor\" >> /etc/portage/package.use"
		elog "and re-emerge splashutils."
	fi

	if ! test -f /proc/cmdline ||
		! egrep -q '(console=tty1|CONSOLE=/dev/tty1)' /proc/cmdline ; then
		elog "It is required that you add 'console=tty1' to your kernel"
		elog "command line parameters."
		elog ""
		elog "After these modifications, the relevant part of the kernel command"
		elog "line might look like:"
		elog "  splash=silent,fadein,theme:emergence console=tty1"
		elog ""
	fi

	if ! has_version 'media-gfx/splash-themes-livecd' &&
		! has_version 'media-gfx/splash-themes-gentoo'; then
		elog "The sample Gentoo themes (emergence, gentoo) have been removed from the"
		elog "core splashutils package. To get some themes you might want to emerge:"
		elog "  media-gfx/splash-themes-livecd"
		elog "  media-gfx/splash-themes-gentoo"
	fi
}
