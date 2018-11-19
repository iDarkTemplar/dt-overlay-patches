# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE="qttools"
inherit desktop gnome2-utils qt5-build-multilib

DESCRIPTION="Tool for viewing on-line documentation in Qt help file format"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~hppa ppc64 x86"
fi

IUSE="examples"

DEPEND="
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qthelp-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtnetwork-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtprintsupport-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtsql-${PV}[sqlite,${MULTILIB_USEDEP}]
	~dev-qt/qtwidgets-${PV}[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/assistant/assistant
)

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples/assistant")
}

src_prepare() {
	sed -i -e "s/qtHaveModule(webkitwidgets)/false/g" \
		src/assistant/assistant/assistant.pro

	qt5-build-multilib_src_prepare
}

multilib_src_install() {
	qt5_multilib_src_install
}

multilib_src_install_all() {
	doicon -s 32 src/assistant/assistant/images/assistant.png
	newicon -s 128 src/assistant/assistant/images/assistant-128.png assistant.png
	make_desktop_entry "${QT5_BINDIR}"/assistant 'Qt 5 Assistant' assistant 'Qt;Development;Documentation'
}

pkg_postinst() {
	qt5-build-multilib_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	qt5-build-multilib_pkg_postrm
	gnome2_icon_cache_update
}
