# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QT6_MODULE="qtwayland"
inherit cmake qt6-build

DESCRIPTION="Wayland platform plugin for Qt"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE="doc examples vulkan X"

BDEPEND="
	doc? ( ~dev-qt/qttools-${PV}:6=[qml] )
	"

DEPEND="
	>=dev-libs/wayland-1.6.0
	~dev-qt/qtbase-${PV}:6=[gui,egl,opengl,vulkan=,X=]
	~dev-qt/qtdeclarative-${PV}:6=
	media-libs/mesa[egl]
	>=x11-libs/libxkbcommon-0.2.0
	vulkan? ( dev-util/vulkan-headers )
	X? (
		~dev-qt/qtbase-${PV}:6=[-gles2-only]
		x11-libs/libX11
		x11-libs/libXcomposite
	)
	!dev-qt/qt-docs
"

src_configure() {
	local mycmakeargs

	qt6_prepare_env

	# bug 633838
	unset QMAKESPEC XQMAKESPEC QMAKEPATH QMAKEFEATURES

	mycmakeargs=(
		# exclude examples and tests from default build
		-DQT_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DQT_BUILD_TESTS=OFF
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
