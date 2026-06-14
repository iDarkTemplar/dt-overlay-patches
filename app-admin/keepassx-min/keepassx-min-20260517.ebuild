# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="KeePassX-min - KeePassX minimal edition"
HOMEPAGE="https://github.com/iDarkTemplar/keepassx-min"

SRC_URI="https://github.com/iDarkTemplar/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="
	app-crypt/argon2:=
	dev-libs/botan:3=
	dev-libs/zxcvbn-c
	dev-qt/qtbase:6[X,concurrent,dbus,gui,widgets]
	dev-qt/qtsvg:6
	kde-frameworks/kwidgetsaddons:6=
	media-gfx/qrencode:=
	virtual/minizip:=
	virtual/zlib:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-qt/qttools:6[linguist]
	test? ( dev-qt/qtbase:6[test] )
"

src_configure() {
	local -a mycmakeargs=(
		-DWITH_TESTS="$(usex test)"
	)

	cmake_src_configure
}
