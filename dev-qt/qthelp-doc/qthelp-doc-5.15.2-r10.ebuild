# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_COMMIT=33693a928986006d79c1ee743733cde5966ac402
QT5_MODULE="qttools"
inherit qt5-build

DESCRIPTION="Documentation for Qt5 module for integrating online documentation into applications"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"
fi

IUSE=""

DEPEND="
	=dev-qt/qthelp-${QT5_PV}*
	=dev-qt/qdoc-${QT5_PV}*[qml]
	=dev-qt/qtattributionsscanner-${QT5_PV}*
	=dev-qt/qthelp-${QT5_PV}*
	!dev-qt/qt-docs:5
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