# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build-extra

DESCRIPTION="Speech Libraries for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"
fi

IUSE="alsa doc flite speechd examples"

BDEPEND="
	doc? ( ~dev-qt/qttools-${PV}:6=[qdoc(+),qtattributionsscanner(+)] )
	"

DEPEND="
	~dev-qt/qtbase-${PV}:6=
	~dev-qt/qtdeclarative-${PV}:6=
	virtual/libudev:=
	flite? (
		~dev-qt/qtmultimedia-${PV}:6=[alsa?]
		app-accessibility/flite[alsa?]
		alsa? ( media-libs/alsa-lib )
	)
	speechd? ( app-accessibility/speech-dispatcher[alsa?] )
	doc? ( !dev-qt/qt-docs:6 )
	examples? ( ~dev-qt/qtbase-${PV}:6=[gui,widgets] )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		# exclude examples and tests from default build
		-DQT_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DQT_BUILD_TESTS=OFF

		-DQT_FEATURE_flite=$(usex flite ON OFF)
		-DQT_FEATURE_speechd=$(usex speechd ON OFF)
	)

	use flite && mycmakeargs+=( -DQT_FEATURE_flite_alsa=$(usex alsa ON OFF) )

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

	cmake_src_install $(usev doc install_docs)

	qt_install_bin_symlinks
}
