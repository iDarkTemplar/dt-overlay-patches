# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qt5-build-multilib

DESCRIPTION="XPath, XQuery, XSLT, and XML Schema validation library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
fi

IUSE="examples"

DEPEND="
	~dev-qt/qtcore-${PV}[${MULTILIB_USEDEP}]
	~dev-qt/qtnetwork-${PV}[${MULTILIB_USEDEP}]
	examples? ( ~dev-qt/qtwidgets-${PV}[${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}"

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples")
}
