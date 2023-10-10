# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Qt HTTP Server"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE="+websocket"

DEPEND="
	~dev-qt/qtbase-${PV}:6=[concurrent,network]
	websocket? ( ~dev-qt/qtwebsockets-${PV}:6= )
"
RDEPEND="${DEPEND}"
