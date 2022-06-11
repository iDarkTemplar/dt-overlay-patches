# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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

# https://invent.kde.org/qt/qt/qttools/-/merge_requests/2
PATCHES=( "${FILESDIR}/qthelp-5.15.4-bogusdep.patch" )

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
