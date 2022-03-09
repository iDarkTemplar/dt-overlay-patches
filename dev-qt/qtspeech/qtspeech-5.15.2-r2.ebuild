# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8
QT5_GENERATE_DOCS="true"
KDE_ORG_COMMIT=16c625528f5e34e698983fc66a7c9cfb96da8052
inherit qt5-build

DESCRIPTION="Text-to-speech library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ppc64 ~riscv x86"
fi

IUSE="alsa examples flite"

RDEPEND="
	>=app-accessibility/speech-dispatcher-0.8.7
	=dev-qt/qtcore-${QT5_PV}*
	examples? (
		=dev-qt/qtwidgets-${QT5_PV}*
	)
	flite? (
		>=app-accessibility/flite-2[alsa?]
		=dev-qt/qtmultimedia-${QT5_PV}*[alsa?]
		alsa? ( media-libs/alsa-lib )
	)
"
DEPEND="${RDEPEND}"

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples")
}

src_prepare() {
	qt_use_disable_config flite flite \
		src/plugins/tts/tts.pro

	qt_use_disable_config alsa flite_alsa \
		src/plugins/tts/flite/flite.pro

	qt5-build_src_prepare
}
