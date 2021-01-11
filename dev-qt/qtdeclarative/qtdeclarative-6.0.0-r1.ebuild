# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QT6_MODULE="qtdeclarative"
inherit cmake qt6-build

DESCRIPTION="The QML and Quick modules for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE="doc examples gles2-only +jit localstorage vulkan +widgets"
REQUIRED_USE="examples? ( widgets )"

DEPEND="
	~dev-qt/qtbase-${PV}:6=[gui,gles2-only=,network,vulkan=,widgets=]
	localstorage? ( ~dev-qt/qtbase-${PV}:6=[sql] )
"

PDEPEND="
	doc? ( ~dev-qt/qtdeclarative-doc-${PV} )
"

src_prepare() {
	qt_use_disable_target localstorage Qt::Sql \
		src/imports/CMakeLists.txt \
		tests/auto/qml/CMakeLists.txt

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
	)

	cmake_src_configure
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

	cmake_src_install

	qt_install_bin_symlinks
}
