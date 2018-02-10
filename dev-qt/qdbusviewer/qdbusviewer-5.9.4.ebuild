# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE="qttools"
inherit desktop gnome2-utils qt5-build-multilib

DESCRIPTION="Graphical tool that lets you introspect D-Bus objects and messages"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~hppa ~ppc64 ~x86"
fi

IUSE=""

DEPEND="
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtdbus-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtwidgets-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtxml-${PV}[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/qdbus/qdbusviewer
)

multilib_src_install() {
	qt5_multilib_src_install

	doicon -s 32 src/qdbus/qdbusviewer/images/qdbusviewer.png
	newicon -s 128 src/qdbus/qdbusviewer/images/qdbusviewer-128.png qdbusviewer.png
	make_desktop_entry "${QT5_BINDIR}"/qdbusviewer 'Qt 5 QDBusViewer' qdbusviewer 'Qt;Development'
}

pkg_postinst() {
	qt5-build-multilib_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	qt5-build-multilib_pkg_postrm
	gnome2_icon_cache_update
}
