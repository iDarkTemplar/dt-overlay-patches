# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8
QT5_GENERATE_DOCS="true"
inherit qt5-build

DESCRIPTION="3D data visualization library for the Qt5 framework"
LICENSE="GPL-3"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm64 x86"
fi

IUSE="examples gles2-only qml"

DEPEND="
	=dev-qt/qtcore-${QT5_PV}*
	=dev-qt/qtgui-${QT5_PV}*[gles2-only=]
	doc? ( =dev-qt/qdoc-${QT5_PV}*[qml?] )
	qml? ( =dev-qt/qtdeclarative-${QT5_PV}*[gles2-only=] )
"
RDEPEND="${DEPEND}"

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples/datavisualization")
}

src_prepare() {
	# eliminate bogus dependency on qtwidgets
	sed -i -e '/requires.*widgets/d' qtdatavis3d.pro || die

	qt_use_disable_mod qml quick \
		src/src.pro \
		examples/datavisualization/datavisualization.pro

	qt5-build_src_prepare
}
