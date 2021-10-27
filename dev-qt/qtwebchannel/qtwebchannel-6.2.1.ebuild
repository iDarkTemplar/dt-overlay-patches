# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake qt6-build

DESCRIPTION="Qt6 module for integrating C++ and QML applications with HTML/JavaScript clients"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~ppc ppc64 ~riscv x86"
fi

IUSE="doc examples qml"
REQUIRED_USE="examples? ( qml )"

BDEPEND="
	doc? ( ~dev-qt/qttools-${PV}:6=[qml?] )
	"

DEPEND="
	~dev-qt/qtbase-${PV}:6=[gui]
	qml? ( ~dev-qt/qtdeclarative-${PV}:6= )
	doc? ( !dev-qt/qt-docs:6 )
	examples? (
		~dev-qt/qtbase-${PV}:6=[widgets]
		~dev-qt/qtwebsockets-${PV}:6=
	)
"
RDEPEND="${DEPEND}"

src_prepare() {
	qt_use_disable_target qml Qt::Quick \
		src/CMakeLists.txt

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
