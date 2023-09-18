# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Qt Language Server"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE=""

DEPEND="
	~dev-qt/qtbase-${PV}:6=[concurrent,network]
"
RDEPEND="${DEPEND}"
