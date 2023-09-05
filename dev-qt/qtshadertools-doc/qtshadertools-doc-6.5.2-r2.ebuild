# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT6_MODULE="qtshadertools"
inherit qt6-build-extra

DESCRIPTION="Documentation for Qt APIs and Tools for Graphics Pipelines"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE=""

BDEPEND="
	~dev-qt/qttools-${PV}:6=[qdoc(+),qtattributionsscanner(+)]
	"

DEPEND="
	~dev-qt/qtshadertools-${PV}:6=
	!dev-qt/qt-docs:6
"

RDEPEND="${DEPEND}"

src_compile() {
	cmake_src_compile docs
}

src_install() {
	qt_install_docs
}
