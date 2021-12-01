# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake qt6-build

DESCRIPTION="Additional format plugins for the Qt image I/O system"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE="doc mng"

BDEPEND="
	doc? ( ~dev-qt/qttools-${PV}:6= )
	"

DEPEND="
	~dev-qt/qtbase-${PV}:6=[gui]
	media-libs/libwebp:=
	media-libs/tiff:0
	mng? ( media-libs/libmng:= )
	doc? ( !dev-qt/qt-docs:6 )
"

RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs

	qt6_prepare_env

	# bug 633838
	unset QMAKESPEC XQMAKESPEC QMAKEPATH QMAKEFEATURES

	mycmakeargs=(
		-DINPUT_jasper=no
		-DINPUT_mng=$(usex mng system no)
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
	cmake_src_install $(usev doc install_docs)

	qt_install_bin_symlinks
}
