# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT5_GENERATE_DOCS="true"
inherit qt5-build

DESCRIPTION="Application scripting library for the Qt5 framework (deprecated)"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"
fi

IUSE="examples +jit scripttools"
REQUIRED_USE="examples? ( scripttools )"

DEPEND="
	=dev-qt/qtcore-${QT5_PV}*
	scripttools? (
		=dev-qt/qtgui-${QT5_PV}*
		=dev-qt/qtwidgets-${QT5_PV}*
	)
"
RDEPEND="${DEPEND}"

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples")
}

src_prepare() {
	qt_use_disable_mod scripttools widgets \
		src/src.pro \
		examples/script/script.pro

	qt5-build_src_prepare
}

src_configure() {
	local myqmakeargs=(
		JAVASCRIPTCORE_JIT=$(usex jit)
	)
	qt5-build_src_configure
}
