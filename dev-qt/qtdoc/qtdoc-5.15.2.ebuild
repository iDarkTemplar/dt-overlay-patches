# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit qt5-build

DESCRIPTION="Qt5 documentation, for use with Qt Creator and other tools"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ppc ppc64 ~sparc x86"
fi

IUSE="examples"

DEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qdoc-${PV}
	~dev-qt/qtattributionsscanner-${PV}
	~dev-qt/qthelp-${PV}
	!dev-qt/qt-docs:5
	examples? (
		~dev-qt/qtdeclarative-${PV}
		~dev-qt/qtquickcontrols-${PV}
		~dev-qt/qtquickcontrols2-${PV}
		~dev-qt/qtxmlpatterns-${PV}
	)
"
RDEPEND="${DEPEND}"

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples")
}

src_compile() {
	qt5-build_src_compile

	qt5_foreach_target_doc_subdir emake docs
}

src_install() {
	qt5-build_src_install

	qt5_foreach_target_doc_subdir emake INSTALL_ROOT="${D}" install_docs
}
