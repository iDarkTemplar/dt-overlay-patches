# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT5_KDEPATCHSET_REV=1
QT5_MODULE="qttools"
inherit qt5-build

DESCRIPTION="Qt documentation generator"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ppc64 ~riscv x86"
fi

IUSE="doc qml"

DEPEND="
	=dev-qt/qtcore-${QT5_PV}*:5=
	sys-devel/clang:=
	qml? ( =dev-qt/qtdeclarative-${QT5_PV}* )
	doc? ( !dev-qt/qt-docs:5 )
"
RDEPEND="${DEPEND}"
BDEPEND="
	doc? (
		=dev-qt/qtattributionsscanner-${QT5_PV}*
		=dev-qt/qthelp-${QT5_PV}*
	)
"

QT5_TARGET_SUBDIRS=(
	src/qdoc
)

src_prepare() {
	qt_use_disable_mod qml qmldevtools-private \
		src/qdoc/qdoc.pro

	qt5-build_src_prepare
}

src_configure() {
	# qt5_tools_configure() not enough here, needs another fix, bug 676948
	mkdir -p "${QT5_BUILD_DIR}"/src/qdoc || die
	qt5_qmake "${QT5_BUILD_DIR}"
	cp src/qdoc/qtqdoc-config.pri "${QT5_BUILD_DIR}"/src/qdoc || die

	qt5-build_src_configure
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
