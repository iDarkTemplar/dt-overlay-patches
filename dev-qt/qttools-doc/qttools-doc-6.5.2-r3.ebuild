# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT6_MODULE="qttools"
inherit qt6-build-extra

DESCRIPTION="Various Qt6 tools, including assistant, designer, linguist, qdoc and others"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE="+assistant +designer +distancefieldgenerator +linguist +pixeltool
	+qdbus +qdoc +qtattributionsscanner +qtdiag +qtplugininfo
	examples"

BDEPEND="
	~dev-qt/qttools-${PV}:6=[qdoc(+),qtattributionsscanner(+)]
	"

DEPEND="
	~dev-qt/qttools-${PV}:6=[assistant=,designer=,distancefieldgenerator=,linguist=,pixeltool=,qdbus=,qdoc=,qtattributionsscanner=,qtdiag=,qtplugininfo=,examples=]
	!dev-qt/qt-docs:6
"

RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		# exclude examples and tests from default build
		-DQT_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DQT_BUILD_TESTS=OFF

		$(qt_feature assistant)
		-DQT_FEATURE_commandlineparser=ON
		$(qt_feature designer)
		$(qt_feature distancefieldgenerator)
		$(qt_feature linguist)
		$(qt_feature pixeltool)
		$(qt_feature qdbus)
		$(qt_feature qdoc clang)
		$(qt_feature qtattributionsscanner)
		$(qt_feature qtdiag)
		$(qt_feature qtplugininfo)
		-DQT_FEATURE_thread=ON
	)

	qt6-build_src_configure
}

src_compile() {
	cmake_src_compile docs
}

src_install() {
	qt_install_docs
}
