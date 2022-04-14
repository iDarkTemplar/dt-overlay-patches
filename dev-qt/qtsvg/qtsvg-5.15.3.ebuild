# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT5_KDEPATCHSET_REV=1
QT5_GENERATE_DOCS="true"
inherit qt5-build

DESCRIPTION="SVG rendering library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"
	SRC_URI+=" https://dev.gentoo.org/~asturm/distfiles/${P}-QTBUG-90744.tar.xz"
fi

IUSE="examples"

RDEPEND="
	=dev-qt/qtcore-${QT5_PV}*
	=dev-qt/qtgui-${QT5_PV}*
	=dev-qt/qtwidgets-${QT5_PV}*
	examples? (
		=dev-qt/qtnetwork-${QT5_PV}*
		=dev-qt/qtopengl-${QT5_PV}*
	)
	sys-libs/zlib:=
"
DEPEND="${RDEPEND}
	test? ( =dev-qt/qtxml-${QT5_PV}* )
"

PATCHES=( "${FILESDIR}"/${P}-QTBUG-90744-minus-binarypatch.patch )

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples")
}

src_unpack() {
	default
	# contains binary patch, so it is applied manually instead
	rm "${WORKDIR}"/${P}-gentoo-kde-1/0003-Make-image-handler-accept-UTF-16-UTF-32-encoded-SVGs.patch || die
}