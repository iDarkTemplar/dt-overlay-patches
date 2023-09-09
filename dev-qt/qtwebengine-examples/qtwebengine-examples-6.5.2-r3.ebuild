# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT6_MODULE="qtwebengine"
inherit qt6-build-extra

DESCRIPTION="Library for rendering dynamic web content in Qt6 C++ and QML applications"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64"
fi

IUSE="designer geolocation kerberos +pepper +print screencast +widgets"

DEPEND="
	~dev-qt/qtwebengine-${PV}:6=[designer=,geolocation=,kerberos=,pepper=,print=,screencast=,widgets=]
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
