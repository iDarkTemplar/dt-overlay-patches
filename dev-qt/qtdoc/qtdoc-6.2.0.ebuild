# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake qt6-build

DESCRIPTION="Qt6 documentation, for use with Qt Creator and other tools"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE="examples"

DEPEND="
	~dev-qt/qtbase-${PV}:6=
	~dev-qt/qttools-${PV}:6=
	examples? (
		~dev-qt/qtbase-${PV}:6=[widgets]
		~dev-qt/qtdeclarative-${PV}:6=
	)
	!dev-qt/qt-docs:6
"

RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs

	qt6_prepare_env

	# bug 633838
	unset QMAKESPEC XQMAKESPEC QMAKEPATH QMAKEFEATURES

	mycmakeargs=(
		# exclude examples and tests from default build
		-DQT_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DQT_BUILD_TESTS=OFF

		-DBUILD_EXAMPLES=$(usex examples ON OFF)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	cmake_src_compile docs
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

	cmake_src_install install_docs

	qt_install_bin_symlinks
}
