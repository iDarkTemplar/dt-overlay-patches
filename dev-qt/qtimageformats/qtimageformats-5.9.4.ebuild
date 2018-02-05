# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qt5-build-multilib

DESCRIPTION="Additional format plugins for the Qt image I/O system"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~hppa ~ppc64 ~x86"
fi

IUSE="jpeg2k mng"

DEPEND="
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[${MULTILIB_USEDEP}]
	media-libs/libwebp:=[${MULTILIB_USEDEP}]
	media-libs/tiff:0[${MULTILIB_USEDEP}]
	jpeg2k? ( media-libs/jasper:=[${MULTILIB_USEDEP}] )
	mng? ( media-libs/libmng:=[${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}"

multilib_src_configure() {
	qt_use_compile_test jpeg2k jasper
	qt_use_compile_test mng libmng
	qt5_multilib_src_configure
}
