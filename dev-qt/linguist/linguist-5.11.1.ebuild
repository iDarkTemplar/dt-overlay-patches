# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE="qttools"
inherit desktop gnome2-utils qt5-build-multilib

DESCRIPTION="Graphical tool for translating Qt applications"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~hppa ~ppc64 x86 ~amd64-fbsd"
fi

IUSE="examples"

DEPEND="
	~dev-qt/designer-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtprintsupport-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtwidgets-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtxml-${PV}[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/linguist/linguist
)

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples/linguist")
}

multilib_src_install() {
	qt5_multilib_src_install
}

multilib_src_install_all() {
	local size
	for size in 16 32 48 64 128; do
		newicon -s ${size} src/linguist/linguist/images/icons/linguist-${size}-32.png linguist.png
	done
	make_desktop_entry "${QT5_BINDIR}"/linguist 'Qt 5 Linguist' linguist 'Qt;Development;Translation'
}

pkg_postinst() {
	qt5-build-multilib_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	qt5-build-multilib_pkg_postrm
	gnome2_icon_cache_update
}
