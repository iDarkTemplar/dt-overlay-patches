# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
QT5_MODULE="qtbase"
inherit qt5-build

DESCRIPTION="Documentation for cross-platform application development framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~sparc x86"
fi

IUSE="gles2-only +ssl vulkan"

DEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtgui-${PV}[gles2-only=,vulkan=]
	~dev-qt/qtwidgets-${PV}[gles2-only=]
	~dev-qt/qtnetwork-${PV}[ssl=]
	~dev-qt/qtconcurrent-${PV}
	~dev-qt/qtdbus-${PV}
	~dev-qt/qtopengl-${PV}[gles2-only=]
	~dev-qt/qtprintsupport-${PV}
	~dev-qt/qtsql-${PV}
	~dev-qt/qttest-${PV}
	~dev-qt/qtxml-${PV}
	~dev-qt/qdoc-${PV}
	~dev-qt/qtattributionsscanner-${PV}
	~dev-qt/qthelp-${PV}
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
