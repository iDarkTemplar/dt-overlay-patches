# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QT6_MODULE="qt3d"
inherit cmake qt6-build

DESCRIPTION="3D rendering module for the Qt6 framework"

SRC_URI="https://download.qt.io/official_releases/additional_libraries/${QT6_MODULE}/${PV%.*}/${PV}/${MY_P}.tar.xz"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE="doc examples gles2-only qml vulkan"
# TODO: tools
# TODO: gamepad dep
# TODO: multimedia dep

BDEPEND="
	doc? ( ~dev-qt/qttools-${PV}:6=[qml=] )
	"

RDEPEND="
	>=media-libs/assimp-5.0.0
	~dev-qt/qtbase-${PV}:6=[gui,opengl,vulkan=]
	~dev-qt/qtshadertools-${PV}:6=
	examples? (
		~dev-qt/qtbase-${PV}:6=[widgets]
		~dev-qt/qtdeclarative-${PV}:6=[widgets]
	)
	qml? (
		~dev-qt/qtdeclarative-${PV}:6=[gles2-only=]
		~dev-qt/qtquick3d-${PV}:6=
	)
	doc? ( !dev-qt/qt-docs:6 )
"

DEPEND="${RDEPEND}
	vulkan? ( dev-util/vulkan-headers )
"

PATCHES=(
	"${FILESDIR}/qt3d-6.0.0-system-assimp.patch"
)

src_prepare() {
	qt_use_disable_target qml Qt::QuickWidgets \
		examples/qt3d/CMakeLists.txt

	qt_use_disable_target qml Qt::Quick \
		src/CMakeLists.txt \
		examples/qt3d/CMakeLists.txt

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs

	qt6_prepare_env

	# bug 633838
	unset QMAKESPEC XQMAKESPEC QMAKEPATH QMAKEFEATURES

	mycmakeargs=(
		# exclude examples and tests from default build
		-DQT_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DQT_BUILD_TESTS=OFF

		-DINPUT_assimp=system
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc; then
		cmake_src_compile docs
	fi
}

src_install() {
	local exampledir
	local installexampledir

	if use examples; then
		# QTBUG-86302: install example sources manually
		while read exampledir ; do
			exampledir="$(dirname "$exampledir")"
			installexampledir="$(dirname "$exampledir")"
			installexampledir="${installexampledir#examples/}"
			insinto "${QT6_EXAMPLESDIR}/${installexampledir}"
			doins -r "${exampledir}"
		done < <(find examples -name CMakeLists.txt 2>/dev/null | xargs grep -l -i project)
	fi

	cmake_src_install $(usex doc install_docs "")

	qt_install_bin_symlinks
}
