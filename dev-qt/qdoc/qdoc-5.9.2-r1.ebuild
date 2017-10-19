# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
QT5_MODULE="qttools"
inherit qt5-build-multilib

DESCRIPTION="Qt documentation generator"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
fi

IUSE="qml"

DEPEND="
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	qml? ( ~dev-qt/qtdeclarative-${PV}[${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/qdoc
)

src_prepare() {
	qt_use_disable_mod qml qmldevtools-private \
		src/qdoc/qdoc.pro

	qt5-build-multilib_src_prepare
}
