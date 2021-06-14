# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils

DESCRIPTION="Hook-based init and shutdown scripts"
HOMEPAGE="https://github.com/iDarkTemplar/dt-init-scripts"

SRC_URI="https://github.com/iDarkTemplar/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="fbsplash luks openrc plymouth rngd swsusp"
REQUIRED_USE="openrc? ( plymouth )"

COMMONDEPEND="
	fbsplash? (
		media-gfx/splashutils:=
	)
	"

DEPEND="$COMMONDEPEND
	fbsplash? (
		virtual/pkgconfig
	)
	"

RDEPEND="$COMMONDEPEND
	sys-apps/coreutils
	sys-apps/busybox
	sys-libs/ncurses
	sys-apps/sysvinit
	sys-fs/e2fsprogs
	app-misc/pax-utils
	app-arch/cpio

	luks? (
		sys-fs/cryptsetup
		app-crypt/gnupg
		app-crypt/pinentry[ncurses]
		sys-apps/util-linux
		app-arch/sharutils
	)

	plymouth? (
		sys-boot/plymouth[-udev]
		media-libs/fontconfig

		openrc? (
			sys-boot/plymouth-openrc-plugin
		)
	)

	rngd? (
		sys-apps/rng-tools
	)

	swsusp? (
		sys-power/suspend
	)
	"

src_compile() {
	if use fbsplash ; then
		emake
	fi
}

src_install() {
	dodir /etc/dt-init-scripts
	insinto /etc/dt-init-scripts
	doins "${S}/configs/dt-init-scripts.conf"

	dodir /usr/libexec/dt-init-scripts/functions
	exeinto /usr/libexec/dt-init-scripts/functions
	doexe "${S}/functions/common"

	dodir /usr/libexec/dt-init-scripts/modules
	exeinto /usr/libexec/dt-init-scripts/modules
	doexe "${S}/modules/base"
	doexe "${S}/modules/suspend"

	dodir /usr/share/dt-init-scripts/helpers
	insinto /usr/share/dt-init-scripts/helpers
	doins "${S}/helpers/busybox-halt"
	doins "${S}/helpers/busybox-poweroff"
	doins "${S}/helpers/busybox-reboot"
	doins "${S}/helpers/linuxrc"
	doins "${S}/helpers/linuxrc-config"
	doins "${S}/helpers/linuxrc-init-finish"
	doins "${S}/helpers/linuxrc-runhooks"
	doins "${S}/helpers/shutdown-newroot-run"

	dodir /usr/share/dt-init-scripts/hooks
	insinto /usr/share/dt-init-scripts/hooks
	doins "${S}/hooks/base"
	doins "${S}/hooks/suspend"

	dosbin "${S}/generate_hooks_initramfs"
	dosbin "${S}/shutdown-newroot-prepare"

	if use fbsplash ; then
		insinto /etc/dt-init-scripts
		doins "${S}/configs/splash-res.conf"
		doins "${S}/configs/splash-theme.conf"

		exeinto /usr/libexec/dt-init-scripts/modules
		doexe "${S}/modules/fbsplash"

		insinto /usr/share/dt-init-scripts/helpers
		doins "${S}/helpers/splash_ctl"

		insinto /usr/share/dt-init-scripts/hooks
		doins "${S}/hooks/fbsplash"

		dosbin "${S}/generate_splash_initramfs"
	fi

	if use luks ; then
		insinto /etc/dt-init-scripts
		doins "${S}/configs/mtab.conf"

		exeinto /usr/libexec/dt-init-scripts/modules
		doexe "${S}/modules/luks"

		insinto /usr/share/dt-init-scripts/hooks
		doins "${S}/hooks/luks"
	fi

	if use plymouth ; then
		exeinto /usr/libexec/dt-init-scripts/modules
		doexe "${S}/modules/plymouth"

		insinto /usr/share/dt-init-scripts/hooks
		doins "${S}/hooks/plymouth"
	fi

	if use rngd ; then
		exeinto /usr/libexec/dt-init-scripts/modules
		doexe "${S}/modules/rngd"

		insinto /usr/share/dt-init-scripts/hooks
		doins "${S}/hooks/rngd"
	fi

	dodoc README
}
