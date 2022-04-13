# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT5_KDEPATCHSET_REV=1
QT5_MODULE="qttools"
inherit qt5-build

DESCRIPTION="Qt5 module for integrating online documentation into applications"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"
fi

IUSE="doc examples"

DEPEND="
	=dev-qt/qtcore-${QT5_PV}*:5=
	=dev-qt/qtgui-${QT5_PV}*
	=dev-qt/qtsql-${QT5_PV}*[sqlite]
	=dev-qt/qtwidgets-${QT5_PV}*
"
RDEPEND="${DEPEND}"

PDEPEND="
	doc? (
		=dev-qt/qthelp-doc-${QT5_PV}*
	)
"

QT5_TARGET_SUBDIRS=(
	src/assistant/help
	src/assistant/qcollectiongenerator
	src/assistant/qhelpgenerator
)

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples/help" "examples/uitools")
}
