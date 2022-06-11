# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT5_KDEPATCHSET_REV=1
QT5_MODULE="qtbase"
inherit qt5-build

DESCRIPTION="Implementation of SAX and DOM for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"
fi

IUSE="doc examples"

RDEPEND="
	=dev-qt/qtcore-${QT5_PV}*:5=
"
DEPEND="${RDEPEND}
	test? ( =dev-qt/qtnetwork-${QT5_PV}* )
"

PDEPEND="
	doc? (
		=dev-qt/qtbase-doc-${QT5_PV}*
	)
	examples? (
		=dev-qt/qtbase-examples-${QT5_PV}*
	)
"

QT5_TARGET_SUBDIRS=(
	src/xml
)

QT5_GENTOO_PRIVATE_CONFIG=(
	:xml
)
