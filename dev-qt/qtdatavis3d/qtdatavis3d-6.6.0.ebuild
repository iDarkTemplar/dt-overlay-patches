# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="3D data visualization library for the Qt6 framework"
LICENSE="GPL-3"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm64 x86"
fi

IUSE="gles2-only"

DEPEND="
	~dev-qt/qtbase-${PV}:6=[gui,opengl,gles2-only=]
	~dev-qt/qtdeclarative-${PV}:6=
"
RDEPEND="${DEPEND}"
