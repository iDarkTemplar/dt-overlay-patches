# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE="qt3d"
inherit qt5-build

DESCRIPTION="Examples for 3D rendering module for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 x86"
fi

# TODO: gamepad, tools
IUSE=""

DEPEND="
	~dev-qt/qt3d-${PV}[qml]
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	examples
)
