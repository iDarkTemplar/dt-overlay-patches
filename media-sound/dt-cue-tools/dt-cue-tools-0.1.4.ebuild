EAPI=5

inherit eutils cmake-multilib

DESCRIPTION="Library for cue sheet reading and tool for flac splitting using information from cue sheet"
HOMEPAGE="https://github.com/iDarkTemplar/dt-cue-tools"

SRC_URI="https://github.com/iDarkTemplar/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+tools"

DEPEND="
	dev-libs/boost:=[${MULTILIB_USEDEP}]
	"

RDEPEND="
	$DEPEND
	tools? (
		media-libs/flac:*
		media-sound/wavpack:*
		virtual/ffmpeg:*
		media-sound/mac:*
	)"

multilib_src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable tools SPLIT_TOOL)
	)

	cmake-utils_src_configure
}
