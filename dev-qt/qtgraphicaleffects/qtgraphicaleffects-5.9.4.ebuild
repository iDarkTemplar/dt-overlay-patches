# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VIRTUALX_REQUIRED="test"
inherit qt5-build-multilib

DESCRIPTION="Set of QML types for adding visual effects to user interfaces"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ppc ppc64 x86"
fi

IUSE=""

RDEPEND="
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtdeclarative-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
