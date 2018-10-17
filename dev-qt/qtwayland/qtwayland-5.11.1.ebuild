# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qt5-build-multilib

DESCRIPTION="Wayland platform plugin for Qt"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 x86"
fi

IUSE="examples +libinput xcomposite"

DEPEND="
	>=dev-libs/wayland-1.6.0[${MULTILIB_USEDEP}]
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtdeclarative-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[egl,libinput?,${MULTILIB_USEDEP}]
	media-libs/mesa[egl,${MULTILIB_USEDEP}]
	>=x11-libs/libxkbcommon-0.2.0[${MULTILIB_USEDEP}]
	xcomposite? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXcomposite[${MULTILIB_USEDEP}]
	)
"
RDEPEND="${DEPEND}"

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples")
}

src_prepare() {
	qt_use_disable_config libinput xkbcommon-evdev \
		src/client/client.pro \
		src/compositor/wayland_wrapper/wayland_wrapper.pri \
		src/plugins/shellintegration/ivi-shell/ivi-shell.pro \
		tests/auto/compositor/compositor/compositor.pro

	use xcomposite || rm -r config.tests/xcomposite || die

	qt5-build-multilib_src_prepare
}
