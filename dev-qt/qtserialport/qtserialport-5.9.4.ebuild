# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qt5-build-multilib

DESCRIPTION="Serial port abstraction library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ppc64 x86"
fi

IUSE="examples"

DEPEND="
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	examples? ( ~dev-qt/qtwidgets-${PV}[${MULTILIB_USEDEP}] )
	virtual/libudev:=[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples")
}

src_prepare() {
	# make sure we link against libudev
	sed -i -e 's/:qtConfig(libudev)//' \
		src/serialport/serialport-lib.pri || die

	qt5-build-multilib_src_prepare
}
