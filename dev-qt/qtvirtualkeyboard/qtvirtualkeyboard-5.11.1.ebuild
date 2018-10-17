# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qt5-build-multilib

DESCRIPTION="Virtual keyboard plugin for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-fbsd"
fi

# TODO: unbudle libraries for more layouts
IUSE="examples handwriting +spell +xcb"

DEPEND="
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtdeclarative-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtsvg-${PV}[${MULTILIB_USEDEP}]
	spell? ( app-text/hunspell:=[${MULTILIB_USEDEP}] )
	xcb? ( x11-libs/libxcb:=[${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}"

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples")
}

multilib_src_configure() {
	local myqmakeargs=(
		$(usex handwriting CONFIG+=lipi-toolkit "")
		$(usex spell "" CONFIG+=disable-hunspell)
		$(usex xcb "" CONFIG+=disable-desktop)
		CONFIG+="lang-ar_AR lang-da_DK lang-de_DE lang-en_GB \
                        lang-es_ES lang-fa_FA lang-fi_FI lang-fr_FR \
                        lang-hi_IN lang-it_IT lang-nb_NO lang-pl_PL \
                        lang-pt_PT lang-ro_RO lang-ru_RU lang-sv_SE"
	)

	qt5_multilib_src_configure
}
