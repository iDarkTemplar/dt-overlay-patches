# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT6_MODULE="qtdeclarative"
inherit qt6-build-extra

DESCRIPTION="Documentation for Qt Declarative (Quick 2)"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE="examples opengl sql +widgets"

BDEPEND="
	~dev-qt/qttools-${PV}:6=[qdoc(+),qtattributionsscanner(+)]
	"

DEPEND="
	~dev-qt/qtdeclarative-${PV}:6=[examples=,opengl=,sql=,widgets=]
	!dev-qt/qt-docs:6
	!dev-qt/qtquickcontrols2:6
"

RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		# exclude examples and tests from default build
		-DQT_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DQT_BUILD_TESTS=OFF

		$(qt_feature opengl)
		$(qt_feature sql)
		$(qt_feature widgets)
	)

	qt6-build_src_configure
}

src_compile() {
	cmake_src_compile docs
}

src_install() {
	qt_install_docs
}
