# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE="qttools"
inherit qt5-build-multilib

DESCRIPTION="Graphical tool for translating Qt applications"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~hppa ~ppc64 ~x86"
fi

IUSE="examples"

DEPEND="
	~dev-qt/designer-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtprintsupport-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtwidgets-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtxml-${PV}[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/linguist/linguist
)

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples/linguist")
}
