# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
QT5_MODULE="qtbase"
inherit qt5-build

DESCRIPTION="Multi-threading concurrence support library for the Qt5 framework"
SRC_URI+=" https://dev.gentoo.org/~asturm/distfiles/qtbase-${PV}-gcc11.patch.xz"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~sparc x86"
fi

IUSE="doc examples"

DEPEND="
	~dev-qt/qtcore-${PV}:5=
"
RDEPEND="${DEPEND}"

PDEPEND="
	doc? (
		~dev-qt/qtbase-doc-${PV}
	)
	examples? (
		~dev-qt/qtbase-examples-${PV}
	)
"

QT5_TARGET_SUBDIRS=(
	src/concurrent
)

PATCHES=(
	"${WORKDIR}"/qtbase-${PV}-gcc11.patch # bug 752012
	"${FILESDIR}"/${P}-gcc11.patch # bug #764977
)
