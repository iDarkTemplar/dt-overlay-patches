# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
QT5_MODULE="qttools"
inherit qt5-build

DESCRIPTION="Documentation for Qt5 module for integrating online documentation into applications"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~sparc x86"
fi

IUSE=""

DEPEND="
	~dev-qt/qthelp-${PV}
	~dev-qt/qdoc-${PV}[qml]
	~dev-qt/qtattributionsscanner-${PV}
	~dev-qt/qthelp-${PV}
	!dev-qt/qt-docs
"
RDEPEND="${DEPEND}"

QT5_TARGET_SUBDIRS=(
	src/assistant/help
	src/assistant/qcollectiongenerator
	src/assistant/qhelpgenerator
)

src_compile() {
	qt5_foreach_target_subdir emake docs
}

src_install() {
	qt5_foreach_target_subdir emake INSTALL_ROOT="${D}" install_docs
}
