# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build-extra

DESCRIPTION="Qt Declarative (Quick 2)"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE="doc examples opengl sql +widgets"

DEPEND="
	~dev-qt/qtbase-${PV}:6=[gui,network,opengl=,sql?,widgets=]
	~dev-qt/qtshadertools-${PV}:6
	!dev-qt/qtquickcontrols2:6
"

RDEPEND="${DEPEND}"

PDEPEND="
	doc? ( ~dev-qt/qtdeclarative-doc-${PV} )
	examples? ( ~dev-qt/qtdeclarative-examples-${PV} )
"

src_configure() {
	local mycmakeargs=(
		# exclude examples and tests from default build
		-DQT_BUILD_EXAMPLES=OFF
		-DQT_BUILD_TESTS=OFF

		$(qt_feature opengl)
		$(qt_feature sql)
		$(qt_feature widgets)
	)

	qt6-build_src_configure
}

src_install() {
	cmake_src_install

	qt_install_bin_symlinks
}
