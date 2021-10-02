# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT6_MODULE="qtdeclarative"
inherit qt6-build

DESCRIPTION="The QML and Quick modules for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE="gles2-only +jit localstorage vulkan"

DEPEND="
	~dev-qt/qtdeclarative-${PV}:6=[gles2-only=,jit=,localstorage=,vulkan=,widgets]
	!dev-qt/qtquickcontrols2:6
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
