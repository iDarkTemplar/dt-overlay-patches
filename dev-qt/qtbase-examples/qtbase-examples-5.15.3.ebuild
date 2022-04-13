# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT5_KDEPATCHSET_REV=1
QT5_MODULE="qtbase"
inherit qt5-build

DESCRIPTION="Examples for cross-platform application development framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"
fi

IUSE="gles2-only vulkan"

DEPEND="
	=dev-qt/qtcore-${QT5_PV}*:5=
	=dev-qt/qtgui-${QT5_PV}*[gles2-only=,vulkan=]
	=dev-qt/qtwidgets-${QT5_PV}*[gles2-only=]
	=dev-qt/qtnetwork-${QT5_PV}*
	=dev-qt/qtconcurrent-${QT5_PV}*
	=dev-qt/qtdbus-${QT5_PV}*
	=dev-qt/qtopengl-${QT5_PV}*[gles2-only=]
	=dev-qt/qtprintsupport-${QT5_PV}*
	=dev-qt/qtsql-${QT5_PV}*
	=dev-qt/qttest-${QT5_PV}*
	=dev-qt/qtxml-${QT5_PV}*
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	examples
)

src_configure() {
	local myconf=(
		-opengl $(usex gles2-only es2 desktop)
		$(qt_use vulkan)
	)
	qt5-build_src_configure
}
