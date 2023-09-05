# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build-extra

DESCRIPTION="Qt module containing the unsupported Qt 5 APIs"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE="doc examples"

BDEPEND="
	doc? ( ~dev-qt/qttools-${PV}:6=[qdoc(+),qtattributionsscanner(+)] )
	"

DEPEND="
	dev-libs/icu:=
	~dev-qt/qtbase-${PV}:6=[icu,gui,network]
	examples? ( ~dev-qt/qtbase-${PV}:6=[widgets] )
	doc? ( !dev-qt/qt-docs:6 )
"

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-6.1.0-examples.patch"
)

src_configure() {
	local mycmakeargs=(
		# exclude examples and tests from default build
		-DQT_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DQT_BUILD_TESTS=OFF
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
}
