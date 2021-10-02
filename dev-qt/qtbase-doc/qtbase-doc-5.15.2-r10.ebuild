# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_COMMIT=a4f9e56975fa6ab4a1f63a9b34a4d77b1cfe4acd
QT5_MODULE="qtbase"
inherit qt5-build

DESCRIPTION="Documentation for cross-platform application development framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"
fi

IUSE="gles2-only +ssl vulkan"

DEPEND="
	=dev-qt/qtcore-${QT5_PV}*
	=dev-qt/qtgui-${QT5_PV}*[gles2-only=,vulkan=]
	=dev-qt/qtwidgets-${QT5_PV}*[gles2-only=]
	=dev-qt/qtnetwork-${QT5_PV}*[ssl=]
	=dev-qt/qtconcurrent-${QT5_PV}*
	=dev-qt/qtdbus-${QT5_PV}*
	=dev-qt/qtopengl-${QT5_PV}*[gles2-only=]
	=dev-qt/qtprintsupport-${QT5_PV}*
	=dev-qt/qtsql-${QT5_PV}*
	=dev-qt/qttest-${QT5_PV}*
	=dev-qt/qtxml-${QT5_PV}*
	=dev-qt/qdoc-${QT5_PV}*
	=dev-qt/qtattributionsscanner-${QT5_PV}*
	=dev-qt/qthelp-${QT5_PV}*
	!dev-qt/qt-docs:5
"
RDEPEND="${DEPEND}"

src_configure() {
	local myconf=(
		-dbus-linked
		-opengl $(usex gles2-only es2 desktop)
		$(qt_use vulkan)
		-gui
		$(usex ssl -openssl-linked '')
		-widgets
	)
	qt5-build_src_configure
}

src_compile() {
	qt5_foreach_target_subdir emake docs
}

src_install() {
	qt5_foreach_target_subdir emake INSTALL_ROOT="${D}" install_docs
}