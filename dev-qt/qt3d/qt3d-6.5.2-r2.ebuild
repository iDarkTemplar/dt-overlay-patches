# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build-extra

DESCRIPTION="3D rendering module for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE="doc examples gles2-only qml vulkan"
# TODO: gamepad dep

BDEPEND="
	doc? ( ~dev-qt/qttools-${PV}:6=[qdoc(+),qtattributionsscanner(+)] )
	"

RDEPEND="
	~dev-qt/qtbase-${PV}:6=[gui,opengl,vulkan=]
	~dev-qt/qtshadertools-${PV}:6=
	media-libs/assimp:=
	examples? (
		~dev-qt/qtbase-${PV}:6=[widgets]
		~dev-qt/qtdeclarative-${PV}:6=[widgets]
		~dev-qt/qtmultimedia-${PV}:6=[qml]
	)
	qml? (
		~dev-qt/qtquick3d-${PV}:6=
	)
	doc? ( !dev-qt/qt-docs:6 )
"

DEPEND="${RDEPEND}
	vulkan? ( dev-util/vulkan-headers )
"

src_prepare() {
	qt_use_disable_target qml Qt::QuickWidgets \
		examples/qt3d/CMakeLists.txt

	qt_use_disable_target qml Qt::Quick \
		src/CMakeLists.txt \
		examples/qt3d/CMakeLists.txt

	qt6-build_src_prepare
}

src_configure() {
	local mycmakeargs=(
		# exclude examples and tests from default build
		-DQT_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DQT_BUILD_TESTS=OFF

		-DINPUT_assimp=system
	)

	qt6-build_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc; then
		cmake_src_compile docs
	fi
}

src_install() {
	if use examples; then
		qt_install_example_sources examples
	fi

	qt6-build_src_install

	if use doc; then
		qt_install_docs
	fi

	dodoc -r tools/utils/exporters/blender
	docompress -x /usr/share/doc/${PF}/blender

	insinto /usr/share/qtcreator/templates/wizards/classes
	doins -r tools/utils/qtcreator/templates/wizards/classes/qt3d
}
