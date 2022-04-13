# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT5_KDEPATCHSET_REV=1
QT5_MODULE="qttools"
inherit qt5-build

DESCRIPTION="Qt5 tool used in documentation generation"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv x86"
fi

IUSE=""

DEPEND="
	=dev-qt/qtcore-${QT5_PV}*:5=
"
RDEPEND="${DEPEND}
	!dev-qt/${PN}:5
	!<dev-qt/qtchooser-66-r2
"

src_install() {
	qt5-build_src_install
	qt5_symlink_binary_to_path qtattributionsscanner
}
