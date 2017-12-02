# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE="qttools"
inherit qt5-build-multilib

DESCRIPTION="WYSIWYG tool for designing and building Qt-based GUIs"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
fi

IUSE="declarative examples webkit"

DEPEND="
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtgui-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtnetwork-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtprintsupport-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtwidgets-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtxml-${PV}[${MULTILIB_USEDEP}]
	declarative? ( ~dev-qt/qtdeclarative-${PV}[widgets,${MULTILIB_USEDEP}] )
	webkit? ( >=dev-qt/qtwebkit-5.9.1:5[${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/designer
)

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples/designer")
}

src_prepare() {
	qt_use_disable_mod declarative quickwidgets \
		src/designer/src/plugins/plugins.pro

	qt_use_disable_mod webkit webkitwidgets \
		src/designer/src/plugins/plugins.pro

	qt5-build-multilib_src_prepare
}
