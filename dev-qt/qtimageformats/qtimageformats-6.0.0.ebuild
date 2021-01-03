# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QT6_MODULE="qtimageformats"
inherit cmake qt6-build

DESCRIPTION="Additional format plugins for the Qt image I/O system"

SRC_URI="https://download.qt.io/official_releases/additional_libraries/${QT6_MODULE}/${PV%.*}/${PV}/${MY_P}.tar.xz"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE="doc"
# TODO: mng USE-flag when mng support is re-enabled

BDEPEND="
	doc? ( ~dev-qt/qttools-${PV}:6= )
	"

DEPEND="
	~dev-qt/qtbase-${PV}:6=[gui]
	media-libs/libwebp:=
	media-libs/tiff:0
	!dev-qt/qt-docs
"

src_configure() {
	local mycmakeargs

	qt6_prepare_env

	# bug 633838
	unset QMAKESPEC XQMAKESPEC QMAKEPATH QMAKEFEATURES

	mycmakeargs=(
		-DINPUT_jasper=no
		-DINPUT_mng=no
		-DINPUT_tiff=system
		-DINPUT_webp=system
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
	cmake_src_install $(usex doc install_docs "")

	qt_install_bin_symlinks
}
