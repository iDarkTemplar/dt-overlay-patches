# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT_MIN_VER="5.9.1:5"
inherit qt5-build

DESCRIPTION="Examples for qtwebkit"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
fi

IUSE=""

RDEPEND="
	~dev-qt/qtwebkit-${PV}[qml]
"
DEPEND="${RDEPEND}
"

QT5_TARGET_SUBDIRS=(
	examples
)
