# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake qt6-build

DESCRIPTION="Customizable input framework and virtual keyboard for Qt"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ppc64 x86"
fi

# TODO: unbudle libraries for more layouts
IUSE="doc examples handwriting +spell +X"

BDEPEND="
	doc? ( ~dev-qt/qttools-${PV}:6= )
	"

DEPEND="
	~dev-qt/qtbase-${PV}:6=[gui]
	~dev-qt/qtdeclarative-${PV}:6=
	~dev-qt/qtsvg-${PV}:6=
	spell? ( app-text/hunspell:= )
	X? ( x11-libs/libxcb:= )
	doc? ( !dev-qt/qt-docs:6 )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs

	qt6_prepare_env

	# bug 633838
	unset QMAKESPEC XQMAKESPEC QMAKEPATH QMAKEFEATURES

	mycmakeargs=(
		-DINPUT_vkb_hunspell=$(usex spell system no)
		-DINPUT_vkb_handwriting=$(usex handwriting t9write no)

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

	cmake_src_install $(usev doc install_docs)

	qt_install_bin_symlinks
}
