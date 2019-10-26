# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit qt5-build

DESCRIPTION="3D rendering module for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 x86"
fi

# TODO: tools
IUSE="examples gamepad gles2 qml"

REQUIRED_USE="examples? ( qml )"

DEPEND="
	~dev-qt/qtconcurrent-${PV}
	~dev-qt/qtcore-${PV}
	~dev-qt/qtgui-${PV}
	~dev-qt/qtnetwork-${PV}
	>=media-libs/assimp-4.0.0
	gamepad? ( ~dev-qt/qtgamepad-${PV} )
	qml? ( ~dev-qt/qtdeclarative-${PV}[gles2=] )
"
RDEPEND="${DEPEND}"

PDEPEND="
	examples? (
		~dev-qt/qt3d-examples-${PV}
	)
"

src_prepare() {
	rm -r src/3rdparty/assimp/{code,contrib,include} || die

	qt_use_disable_mod gamepad gamepad src/input/frontend/frontend.pri
	qt_use_disable_mod qml quick src/src.pro

	qt5-build_src_prepare
}
