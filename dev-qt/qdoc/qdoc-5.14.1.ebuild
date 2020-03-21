# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
QT5_MODULE="qttools"
inherit qt5-build toolchain-funcs

DESCRIPTION="Qt documentation generator"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"
fi

IUSE="doc qml"

DEPEND="
	~dev-qt/qtcore-${PV}
	sys-devel/clang:=
	qml? ( ~dev-qt/qtdeclarative-${PV} )
	doc? ( !dev-qt/qt-docs )
"
RDEPEND="${DEPEND}"
BDEPEND="
	doc? (
		~dev-qt/qtattributionsscanner-${PV}
		~dev-qt/qthelp-${PV}
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-5.14.1-includes.patch"
)

QT5_TARGET_SUBDIRS=(
	src/qdoc
)

src_prepare() {
	qt_use_disable_mod qml qmldevtools-private \
		src/qdoc/qdoc.pro

	qt5-build_src_prepare
}

src_configure() {
	# fix documentation generation
	append-flags -DQDOC_PASS_ISYSTEM

	# src/qdoc requires files that are only generated when qmake is
	# run in the root directory. bug 676948; same fix as bug 633776
	mkdir -p "${QT5_BUILD_DIR}"/src/qdoc || die
	qt5_qmake "${QT5_BUILD_DIR}"
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
