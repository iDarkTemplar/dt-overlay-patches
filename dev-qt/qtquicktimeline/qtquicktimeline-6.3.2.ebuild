# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build-extra

DESCRIPTION="Qt module for keyframe-based timeline construction"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE="doc"

BDEPEND="
	doc? ( ~dev-qt/qttools-${PV}:6=[qdoc(+),qtattributionsscanner(+)] )
	"

DEPEND="
	~dev-qt/qtbase-${PV}:6=
	~dev-qt/qtdeclarative-${PV}:6=
	doc? ( !dev-qt/qt-docs:6 )
"

RDEPEND="${DEPEND}"

src_compile() {
	cmake_src_compile

	if use doc; then
		cmake_src_compile docs
	fi
}

src_install() {
	cmake_src_install $(usev doc install_docs)

	qt_install_bin_symlinks
}
