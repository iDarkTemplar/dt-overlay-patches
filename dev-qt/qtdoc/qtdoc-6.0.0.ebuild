# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QT6_MODULE="qtdoc"
inherit cmake qt6-build

DESCRIPTION="Qt6 documentation, for use with Qt Creator and other tools"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE="examples"
# TODO: example sources

DEPEND="
	~dev-qt/qtbase-${PV}:6=
	~dev-qt/qttools-${PV}:6=
	examples? ( ~dev-qt/qtbase-${PV}:6=[widgets] )
	!dev-qt/qt-docs
"

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
	cmake_src_install install_docs

	qt_install_bin_symlinks
}
