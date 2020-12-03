# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{3_6,3_7,3_8,3_9} )
inherit distutils-r1 qmake-utils toolchain-funcs cmake

DESCRIPTION="Static analyzer of C/C++ code"
HOMEPAGE="https://github.com/danmar/cppcheck"
SRC_URI="https://github.com/danmar/cppcheck/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc64 ~sparc ~x86"
IUSE="doc htmlreport pcre qchart qt5 z3"
REQUIRED_USE="qchart? ( qt5 )"

RDEPEND="
	dev-libs/tinyxml2:=
	htmlreport? ( dev-python/pygments[${PYTHON_USEDEP}] )
	pcre? ( dev-libs/libpcre )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtprintsupport:5
		dev-qt/qthelp:5
		dev-qt/linguist:5
	)
	qchart? ( dev-qt/qtcharts:5 )
	z3? ( sci-mathematics/z3:= )
"
DEPEND="${RDEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	virtual/pkgconfig
	doc? ( app-text/pandoc )
"
PATCHES=(
	"${FILESDIR}"/${PN}-2.2-tinyxml.patch
	"${FILESDIR}"/${PN}-2.2-translations.patch
	"${FILESDIR}"/${PN}-2.2-exprengine.patch
	"${FILESDIR}"/${PN}-2.2-online-help.patch
	"${FILESDIR}"/${PN}-gcc11.patch
	"${FILESDIR}"/${PN}-2.2-online-help_q_readonly.patch
)

src_prepare() {
	cmake_src_prepare

	rm -r externals/tinyxml || die

	# Generate the Qt online-help file
	cd gui/help
	qhelpgenerator online-help.qhcp -o online-help.qhc
}

src_configure() {
	local mycmakeargs

	mycmakeargs=(
		-DUSE_MATCHCOMPILER=yes
		-DUSE_Z3=$(usex z3)
		-DHAVE_RULES=$(usex pcre)
		-DBUILD_GUI=$(usex qt5)
		-DWITH_QCHART=$(usex qchart)
		-DBUILD_SHARED_LIBS:BOOL=OFF
		-DBUILD_TESTS=no
		-DFILESDIR=/usr/share/Cppcheck
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc ; then
		make DB2MAN=/usr/share/sgml/docbook/xsl-stylesheets/manpages/docbook.xsl man
		pandoc man/manual.md -o man/manual.html -s --number-sections --toc
		pandoc man/reference-cfg-format.md -o man/reference-cfg-format.html -s --number-sections --toc
	fi
}

src_install() {
	cmake_src_install

	insinto "/usr/share/${PN}/cfg"
	doins cfg/*.cfg

	dodoc -r tools/triage

	if use doc ; then
		doman ${PN}.1
	fi

	if use qt5 ; then
		insinto /usr/share/pixmaps
		doins gui/cppcheck-gui.png

		insinto /usr/share/Cppcheck/help
		doins gui/help/online-help.qhc
		doins gui/help/online-help.qch
	fi

	if use htmlreport ; then
		dobin htmlreport/cppcheck-htmlreport
	fi
}
