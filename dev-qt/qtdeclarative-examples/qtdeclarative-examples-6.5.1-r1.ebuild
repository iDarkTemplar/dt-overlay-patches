# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT6_MODULE="qtdeclarative"
inherit qt6-build-extra

DESCRIPTION="Examples for Qt Declarative (Quick 2)"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE="opengl sql +widgets"

DEPEND="
	~dev-qt/qtdeclarative-${PV}:6=[opengl=,sql=,widgets=]
	!dev-qt/qtquickcontrols2:6
"

RDEPEND="${DEPEND}"

S="${S}/examples"

src_configure() {
	eqmake6_configure
}

src_compile() {
	eqmake6_compile
}

src_install() {
	qt_install_example_sources .

	eqmake6_install
}
