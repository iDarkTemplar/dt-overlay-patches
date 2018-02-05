# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qt5-build-multilib

DESCRIPTION="3D data visualization library for the Qt5 framework"
LICENSE="GPL-3"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~x86"
fi

IUSE="examples gles2 qml"

DEPEND="
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[gles2=,${MULTILIB_USEDEP}]
	qml? ( ~dev-qt/qtdeclarative-${PV}[gles2=,${MULTILIB_USEDEP}] )
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

	qt5-build-multilib_src_prepare
}
