# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE="qtbase"
VIRTUALX_REQUIRED="test"
inherit qt5-build-multilib

DESCRIPTION="Unit testing library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
fi

IUSE="examples"

RDEPEND="
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		~dev-qt/qtgui-${PV}[${MULTILIB_USEDEP}]
		~dev-qt/qtxml-${PV}[${MULTILIB_USEDEP}]
	)
"

PDEPEND="
	examples? (
		~dev-qt/qtbase-examples-${PV}
	)
"

QT5_TARGET_SUBDIRS=(
	src/testlib
)