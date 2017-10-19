# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE="qtbase"
inherit qt5-build-multilib

DESCRIPTION="Implementation of SAX and DOM for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
fi

IUSE="examples"

RDEPEND="
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( ~dev-qt/qtnetwork-${PV}[${MULTILIB_USEDEP}] )
"

PDEPEND="
	examples? (
		~dev-qt/qtbase-examples-${PV}
	)
"

QT5_TARGET_SUBDIRS=(
	src/xml
)
