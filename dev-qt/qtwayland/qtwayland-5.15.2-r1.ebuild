# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
QT5_GENERATE_DOCS="true"
inherit qt5-build

DESCRIPTION="Wayland platform plugin for Qt"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~sparc x86"
fi

IUSE="examples vulkan X"

DEPEND="
	>=dev-libs/wayland-1.6.0
	~dev-qt/qtcore-${PV}
	~dev-qt/qtdeclarative-${PV}
	~dev-qt/qtgui-${PV}[egl,libinput,vulkan=]
	media-libs/mesa[egl]
	>=x11-libs/libxkbcommon-0.2.0
	vulkan? ( dev-util/vulkan-headers )
	X? (
		~dev-qt/qtgui-${PV}[-gles2-only]
		x11-libs/libX11
		x11-libs/libXcomposite
	)
	doc? ( ~dev-qt/qdoc-${PV}[qml] )
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-qtwaylandscanner-avoid-dangling-pointers.patch )

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples")
}

src_configure() {
	local myqmakeargs=(
		--
		$(qt_use vulkan feature-wayland-vulkan-server-buffer)
		$(qt_use X feature-xcomposite-egl)
		$(qt_use X feature-xcomposite-glx)
	)
	qt5-build_src_configure
}
