# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE="qtbase"
inherit qt5-build-multilib

DESCRIPTION="The GUI module and platform plugins for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ppc ppc64 x86"
fi

# TODO: linuxfb

IUSE="accessibility dbus egl eglfs evdev examples +gif gles2 ibus
	jpeg +libinput +png tslib tuio +udev vnc +xcb"
REQUIRED_USE="
	|| ( eglfs xcb )
	accessibility? ( dbus xcb )
	eglfs? ( egl )
	ibus? ( dbus )
	libinput? ( udev )
	xcb? ( gles2? ( egl ) )
"

RDEPEND="
	dev-libs/glib:2[${MULTILIB_USEDEP}]
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	media-libs/fontconfig[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.6.1:2[${MULTILIB_USEDEP}]
	>=media-libs/harfbuzz-1.0.6:=[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.5[${MULTILIB_USEDEP}]
	virtual/opengl[${MULTILIB_USEDEP}]
	dbus? ( ~dev-qt/qtdbus-${PV}[${MULTILIB_USEDEP}] )
	egl? ( media-libs/mesa[egl,${MULTILIB_USEDEP}] )
	eglfs? (
		media-libs/mesa[gbm,${MULTILIB_USEDEP}]
		x11-libs/libdrm[${MULTILIB_USEDEP}]
	)
	evdev? ( sys-libs/mtdev[${MULTILIB_USEDEP}] )
	gles2? ( media-libs/mesa[gles2,${MULTILIB_USEDEP}] )
	jpeg? ( virtual/jpeg:0[${MULTILIB_USEDEP}] )
	libinput? (
		dev-libs/libinput:=[${MULTILIB_USEDEP}]
		x11-libs/libxkbcommon[${MULTILIB_USEDEP}]
	)
	png? ( media-libs/libpng:0=[${MULTILIB_USEDEP}] )
	tslib? ( x11-libs/tslib[${MULTILIB_USEDEP}] )
	tuio? ( ~dev-qt/qtnetwork-${PV}[${MULTILIB_USEDEP}] )
	udev? ( virtual/libudev:=[${MULTILIB_USEDEP}] )
	vnc? ( ~dev-qt/qtnetwork-${PV}[${MULTILIB_USEDEP}] )
	xcb? (
		x11-libs/libICE[${MULTILIB_USEDEP}]
		x11-libs/libSM[${MULTILIB_USEDEP}]
		x11-libs/libX11[${MULTILIB_USEDEP}]
		>=x11-libs/libXi-1.7.5[${MULTILIB_USEDEP}]
		>=x11-libs/libxcb-1.10:=[xkb,${MULTILIB_USEDEP}]
		>=x11-libs/libxkbcommon-0.4.1[X,${MULTILIB_USEDEP}]
		x11-libs/xcb-util-image[${MULTILIB_USEDEP}]
		x11-libs/xcb-util-keysyms[${MULTILIB_USEDEP}]
		x11-libs/xcb-util-renderutil[${MULTILIB_USEDEP}]
		x11-libs/xcb-util-wm[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	evdev? ( sys-kernel/linux-headers )
	udev? ( sys-kernel/linux-headers )
"
PDEPEND="
	ibus? ( app-i18n/ibus )
	examples? (
		~dev-qt/qtbase-examples-${PV}[gles2=]
	)
"

QT5_TARGET_SUBDIRS=(
	src/gui
	src/openglextensions
	src/platformheaders
	src/platformsupport
	src/plugins/generic
	src/plugins/imageformats
	src/plugins/platforms
	src/plugins/platforminputcontexts
)

QT5_GENTOO_CONFIG=(
	accessibility:accessibility-atspi-bridge
	egl
	eglfs
	eglfs:eglfs_egldevice:
	eglfs:eglfs_gbm:
	evdev
	evdev:mtdev:
	:fontconfig
	:system-freetype:FREETYPE
	!:no-freetype:
	!gif:no-gif:
	gles2::OPENGL_ES
	gles2:opengles2:OPENGL_ES_2
	!:no-gui:
	:system-harfbuzz:HARFBUZZ
	!:no-harfbuzz:
	jpeg:system-jpeg:IMAGEFORMAT_JPEG
	!jpeg:no-jpeg:
	libinput
	libinput:xkbcommon-evdev:
	:opengl
	png:png:
	png:system-png:IMAGEFORMAT_PNG
	!png:no-png:
	tslib
	udev:libudev:
	xcb:xcb:
	xcb:xcb-glx:
	xcb:xcb-plugin:
	xcb:xcb-render:
	xcb:xcb-sm:
	xcb:xcb-xlib:
	xcb:xinput2:
	xcb::XKB
)

QT5_GENTOO_PRIVATE_CONFIG=(
	:gui
)

src_prepare() {
	# egl_x11 is activated when both egl and xcb are enabled
	use egl && QT5_GENTOO_CONFIG+=(xcb:egl_x11) || QT5_GENTOO_CONFIG+=(egl:egl_x11)

	qt_use_disable_config dbus dbus \
		src/platformsupport/themes/genericunix/genericunix.pri

	qt_use_disable_config tuio udpsocket src/plugins/generic/generic.pro

	qt_use_disable_mod ibus dbus \
		src/plugins/platforminputcontexts/platforminputcontexts.pro

	use vnc || sed -i -e '/SUBDIRS += vnc/d' \
		src/plugins/platforms/platforms.pro || die

	qt5-build-multilib_src_prepare
}

multilib_src_configure() {
	local myconf=(
		$(usex dbus -dbus-linked '')
		$(qt_use egl)
		$(qt_use eglfs)
		$(usex eglfs '-gbm -kms' '')
		$(qt_use evdev)
		$(qt_use evdev mtdev)
		-fontconfig
		-system-freetype
		$(usex gif '' -no-gif)
		-gui
		-system-harfbuzz
		$(qt_use jpeg libjpeg system)
		$(qt_use libinput)
		$(qt_use libinput xkbcommon-evdev)
		-opengl $(usex gles2 es2 desktop)
		$(qt_use png libpng system)
		$(qt_use tslib)
		$(qt_use udev libudev)
		$(qt_use xcb xcb system)
		$(qt_use xcb xkbcommon-x11 system)
		$(usex xcb '-xcb-xlib -xinput2 -xkb' '')
	)
	qt5_multilib_src_configure
}