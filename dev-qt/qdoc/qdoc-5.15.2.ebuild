# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
QT5_MODULE="qttools"
inherit qt5-build

DESCRIPTION="Qt documentation generator"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ppc64 x86"
fi

IUSE="doc qml"

DEPEND="
	~dev-qt/qtcore-${PV}:5=
	sys-devel/clang:=
	qml? ( ~dev-qt/qtdeclarative-${PV} )
	doc? ( !dev-qt/qt-docs )
"
RDEPEND="${DEPEND}
	dev-qt/qtchooser
"
BDEPEND="
	doc? (
		~dev-qt/qtattributionsscanner-${PV}
		~dev-qt/qthelp-${PV}
	)
"

src_prepare() {
	qt_use_disable_mod qml qmldevtools-private \
		src/qdoc/qdoc.pro

	qt5-build_src_prepare
}

src_compile() {
	qt5-build_src_compile

	if use doc ; then
		qt5_foreach_target_subdir emake docs
	fi
}

src_install() {
	qt5-build_src_install

	if use doc ; then
		qt5_foreach_target_subdir emake INSTALL_ROOT="${D}" install_docs
	fi
}
