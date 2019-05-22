# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE="qtbase"
inherit qt5-build

DESCRIPTION="Implementation of SAX and DOM for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm ~arm64 ~hppa ppc ppc64 ~sparc x86 ~amd64-fbsd"
fi

IUSE="examples"

RDEPEND="
	~dev-qt/qtcore-${PV}
"
DEPEND="${RDEPEND}
	test? ( ~dev-qt/qtnetwork-${PV} )
"

PDEPEND="
	examples? (
		~dev-qt/qtbase-examples-${PV}
	)
"

QT5_TARGET_SUBDIRS=(
	src/xml
)

QT5_GENTOO_PRIVATE_CONFIG=(
	:xml
)
