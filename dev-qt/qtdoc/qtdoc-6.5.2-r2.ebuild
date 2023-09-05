# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build-extra

DESCRIPTION="Qt6 documentation, for use with Qt Creator and other tools"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE="examples"

DEPEND="
	~dev-qt/qtbase-${PV}:6=
	~dev-qt/qttools-${PV}:6=[qdoc(+),qtattributionsscanner(+)]
	examples? (
		~dev-qt/qtbase-${PV}:6=[widgets]
		~dev-qt/qtdeclarative-${PV}:6=
	)
	!dev-qt/qt-docs:6
"

RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		# exclude examples and tests from default build
		-DQT_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DQT_BUILD_TESTS=OFF

		-DBUILD_EXAMPLES=$(usex examples ON OFF)
	)

	qt6-build_src_configure
}

src_compile() {
	cmake_src_compile
	cmake_src_compile docs
}

src_install() {
	if use examples; then
		qt_install_example_sources examples
	fi

	qt6-build_src_install
	qt_install_docs
}
