# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils

DESCRIPTION="Qt terminal emulator widget"
HOMEPAGE="https://github.com/lxqt/qtermwidget"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5=
	dev-qt/qtgui:5=
	dev-qt/qtwidgets:5=
"
DEPEND="${DEPEND}
	>=dev-util/lxqt-build-tools-0.5.0
"

src_configure() {
	local mycmakeargs=(
		-DPULL_TRANSLATIONS=OFF
		-DQTERMWIDGET_BUILD_PYTHON_BINDING=OFF
	)

	cmake-utils_src_configure
}
