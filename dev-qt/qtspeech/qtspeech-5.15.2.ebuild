# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
QT5_GENERATE_DOCS="true"
inherit qt5-build

DESCRIPTION="Text-to-speech library for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ppc64 x86"
fi

# TODO: flite plugin - needs 2.0.0 (not yet in tree)
IUSE="examples"

RDEPEND="
	>=app-accessibility/speech-dispatcher-0.8.7
	~dev-qt/qtcore-${PV}
	examples? (
		~dev-qt/qtwidgets-${PV}
	)
"
DEPEND="${RDEPEND}"

pkg_setup() {
	use examples && QT5_EXAMPLES_SUBDIRS=("examples")
}
