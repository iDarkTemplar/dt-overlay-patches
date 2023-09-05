# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build-extra

DESCRIPTION="Qt APIs and Tools for Graphics Pipelines"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE="doc"

DEPEND="
	~dev-qt/qtbase-${PV}:6=[gui]
"

RDEPEND="${DEPEND}"

PDEPEND="
	doc? ( ~dev-qt/qtshadertools-doc-${PV} )
"
