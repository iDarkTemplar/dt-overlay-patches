# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT6_MODULE="qtwebengine"
inherit qt6-build

DESCRIPTION="Library for rendering dynamic web content in Qt6 C++ and QML applications"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64"
fi

IUSE="geolocation pepper print"

DEPEND="
	~dev-qt/qtwebengine-${PV}:6=[geolocation=,pepper=,print=]
"

RDEPEND="${DEPEND}"

S="${S}/examples"

src_configure() {
	qt6_prepare_env

	eqmake6_configure
}

src_compile() {
	eqmake6_compile
}

src_install() {
	local exampledir
	local installexampledir

	# QTBUG-86302: install example sources manually
	while read exampledir ; do
		exampledir="$(dirname "$exampledir")"
		installexampledir="$(dirname "$exampledir")"
		installexampledir="${installexampledir#examples/}"
		insinto "${QT6_EXAMPLESDIR}/${installexampledir}"
		doins -r "${exampledir}"
	done < <(find examples -name CMakeLists.txt 2>/dev/null | xargs grep -l -i project)

	eqmake6_install
}
