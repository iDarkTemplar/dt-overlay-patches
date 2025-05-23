# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

inherit cmake python-single-r1 xdg

DESCRIPTION="Android File Transfer for Linux"
HOMEPAGE="https://github.com/whoozle/android-file-transfer-linux"

if [[ "${PV}" = *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/whoozle/android-file-transfer-linux.git"
else
	SRC_URI="https://github.com/whoozle/android-file-transfer-linux/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"

IUSE="fuse python qt6 taglib zune"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	sys-apps/file
	sys-libs/readline:0=
	fuse? ( sys-fs/fuse:0 )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/pybind11[${PYTHON_USEDEP}]
		')
	)
	qt6? (
		dev-qt/qtbase:6[gui,network,widgets]
	)
	taglib? ( media-libs/taglib:= )
	zune? (
		dev-libs/openssl:0=
	)
"

DEPEND="${RDEPEND}"

BDEPEND="
	virtual/pkgconfig
	qt6? ( dev-qt/qttools:6[linguist] )
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.3-qt6-compat.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_FUSE="$(usex fuse)"
		-DBUILD_MTPZ="$(usex zune)"
		-DBUILD_PYTHON="$(usex python)"
		-DBUILD_QT_UI="$(usex qt6)"
		-DBUILD_SHARED_LIB="ON"
		-DBUILD_TAGLIB="$(usex taglib)"
		# Upstream recommends to keep this off as libusb is broken
		-DUSB_BACKEND_LIBUSB="OFF"
		$(usev qt6 '-DDESIRED_QT_VERSION=6')
	)
	cmake_src_configure
}
