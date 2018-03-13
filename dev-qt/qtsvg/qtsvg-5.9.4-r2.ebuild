# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qt5-build-multilib

DESCRIPTION="SVG rendering library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
fi

IUSE="examples"

RDEPEND="
	~dev-qt/qtcore-${PV}-r1:${SLOT}[${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtwidgets-${PV}-r1:${SLOT}[${MULTILIB_USEDEP}]
	examples? (
		~dev-qt/qtnetwork-${PV}[${MULTILIB_USEDEP}]
		~dev-qt/qtopengl-${PV}[${MULTILIB_USEDEP}]
	)
	>=sys-libs/zlib-1.2.5[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( ~dev-qt/qtxml-${PV}[${MULTILIB_USEDEP}] )
"

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples")
}
