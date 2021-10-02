# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake qt6-build

DESCRIPTION="Qt ShaderTools Libraries"

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

src_configure() {
	qt6_prepare_env

	# bug 633838
	unset QMAKESPEC XQMAKESPEC QMAKEPATH QMAKEFEATURES

	cmake_src_configure
}

src_install() {
	cmake_src_install

	qt_install_bin_symlinks
}
