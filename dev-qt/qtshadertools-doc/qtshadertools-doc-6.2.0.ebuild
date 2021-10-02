# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT6_MODULE="qtshadertools"
inherit cmake qt6-build

DESCRIPTION="Qt ShaderTools Libraries"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE=""

BDEPEND="
	~dev-qt/qttools-${PV}:6=
	"

DEPEND="
	~dev-qt/qtshadertools-${PV}:6=
	!dev-qt/qt-docs:6
"

RDEPEND="${DEPEND}"

src_configure() {
	qt6_prepare_env

	# bug 633838
	unset QMAKESPEC XQMAKESPEC QMAKEPATH QMAKEFEATURES

	cmake_src_configure
}

src_compile() {
	cmake_src_compile docs
}

src_install() {
	DESTDIR="${D}" cmake_src_compile install_docs
}
