# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic qmake-utils xdg

DESCRIPTION="E-Book Reader. Supports many e-book formats"
HOMEPAGE="https://www.fbreader.org/"
SRC_URI="https://www.fbreader.org/files/desktop/${PN}-sources-${PV}.tgz
	!qt6? ( https://dev.gentoo.org/~juippis/distfiles/tmp/fbreader-0.99.4-combined.patch )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86"
IUSE="debug qt6"

RDEPEND="
	app-arch/bzip2
	dev-db/sqlite
	dev-libs/expat
	dev-libs/fribidi
	dev-libs/libunibreak
	net-misc/curl
	sys-libs/zlib
	!qt6? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5[ssl]
		dev-qt/qtwidgets:5
	)
	qt6? (
		dev-qt/qtbase:6[gui,network,ssl,widgets]
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

# bugs #452636, #515698, #516794, #437262, #592588
pkg_setup() {
	! use qt6 && PATCHES+=( "${DISTDIR}"/${P}-combined.patch )
	use qt6 && PATCHES+=( "${FILESDIR}"/${P}-combined-qt6.patch )
}

src_prepare() {
	default

	! use qt6 && append-cflags -std=c++11
	use qt6 && append-cflags -std=c++17

	# Let portage decide about the compiler
	sed -e "/^CC = /d" \
		-i makefiles/arch/desktop.mk || die "removing CC line failed"

	# let portage strip the binary
	sed -e '/@strip/d' \
		-i fbreader/desktop/Makefile || die

	# Respect *FLAGS
	sed -e "s/^CFLAGS = -pipe/CFLAGS +=/" \
		-i makefiles/arch/desktop.mk || die "CFLAGS sed failed"
	sed -e "/^	CFLAGS +=/d" \
		-i makefiles/config.mk || die "CFLAGS sed failed"
	sed -e "/^	LDFLAGS += -s$/d" \
		-i makefiles/config.mk || die "LDFLAGS sed failed"
	sed -e "/^LDFLAGS =$/d" \
		-i makefiles/arch/desktop.mk || die "LDFLAGS sed failed"

	echo "TARGET_ARCH = desktop" > makefiles/target.mk || die
	echo "LIBDIR = /usr/$(get_libdir)" >> makefiles/target.mk || die

	echo "UI_TYPE = qt4" >> makefiles/target.mk || die

	if use debug; then
		echo "TARGET_STATUS = debug" >> makefiles/target.mk || die
	else
		echo "TARGET_STATUS = release" >> makefiles/target.mk || die
	fi
}

src_compile() {
	# bug #484516
	emake -j1
}

src_install() {
	default
	dosym FBReader /usr/bin/fbreader
}
