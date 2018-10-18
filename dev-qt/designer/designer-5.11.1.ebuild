# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE="qttools"
inherit desktop gnome2-utils qt5-build-multilib

DESCRIPTION="WYSIWYG tool for designing and building Qt-based GUIs"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 x86 ~amd64-fbsd"
fi

IUSE="declarative examples"

DEPEND="
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtnetwork-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtprintsupport-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtwidgets-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtxml-${PV}[${MULTILIB_USEDEP}]
	declarative? ( ~dev-qt/qtdeclarative-${PV}[widgets,${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/designer
)

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples/designer")
}

src_prepare() {
	qt_use_disable_mod declarative quickwidgets \
		src/designer/src/plugins/plugins.pro

	sed -i -e "s/qtHaveModule(webkitwidgets)/false/g" \
		src/designer/src/plugins/plugins.pro

	qt5-build-multilib_src_prepare
}

multilib_src_install() {
	qt5_multilib_src_install

	doicon -s 128 src/designer/src/designer/images/designer.png
	make_desktop_entry "${QT5_BINDIR}"/designer 'Qt 5 Designer' designer 'Qt;Development;GUIDesigner'
}

pkg_postinst() {
	qt5-build-multilib_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	qt5-build-multilib_pkg_postrm
	gnome2_icon_cache_update
}
