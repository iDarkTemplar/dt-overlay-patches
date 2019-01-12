# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qt5-build-multilib

DESCRIPTION="Implementation of the WebSocket protocol for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc x86"
fi

IUSE="examples qml +ssl"

DEPEND="
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtnetwork-${PV}[ssl=,${MULTILIB_USEDEP}]
	qml? ( ~dev-qt/qtdeclarative-${PV}[${MULTILIB_USEDEP}] )

"
RDEPEND="${DEPEND}"

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples")
}

src_prepare() {
	qt_use_disable_mod qml quick \
		src/src.pro \
		examples/websockets/websockets.pro

	qt5-build-multilib_src_prepare
}
