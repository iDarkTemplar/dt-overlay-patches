# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE="qttools"
inherit qt5-build-multilib

DESCRIPTION="Qt screen magnifier"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~hppa ~ppc64 ~sparc x86"
fi

IUSE=""

DEPEND="
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtwidgets-${PV}[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/pixeltool
)
