# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit distutils-r1 toolchain-funcs cmake

DESCRIPTION="Static analyzer of C/C++ code"
HOMEPAGE="https://github.com/danmar/cppcheck"
SRC_URI="https://github.com/danmar/cppcheck/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc64 ~sparc ~x86"
IUSE="doc htmlreport pcre qchart qt6"
REQUIRED_USE="qchart? ( qt6 )"

RDEPEND="
	dev-libs/tinyxml2:=
	htmlreport? ( dev-python/pygments[${PYTHON_USEDEP}] )
	pcre? ( dev-libs/libpcre )
	qt6? (
		dev-qt/qtbase:6
		dev-qt/qttools:6
	)
	qchart? ( dev-qt/qtcharts:6 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	virtual/pkgconfig
	doc? ( virtual/pandoc )
"
PATCHES=(
	"${FILESDIR}"/${PN}-2.10-translations.patch
)

src_prepare() {
	cmake_src_prepare

	rm -r externals/tinyxml2 || die

	if use qt6 ; then
		# Generate the Qt online-help file
		cd gui/help
		$(qmake6 -query QT_INSTALL_LIBEXECS)/qhelpgenerator online-help.qhcp -o online-help.qhc
	fi
}

src_configure() {
	local mycmakeargs=(
		-DHAVE_RULES="$(usex pcre)"
		-DBUILD_GUI="$(usex qt6)"
		-DUSE_QT6="$(usex qt6)"
		-DFILESDIR="${EPREFIX}/usr/share/Cppcheck"
		-DUSE_BUNDLED_TINYXML2=OFF
		-DUSE_MATCHCOMPILER=On
		-DWITH_QCHART=$(usex qchart)
		-DBUILD_SHARED_LIBS:BOOL=OFF
		-DBUILD_TESTS=no
		-DUSE_BOOST=no
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

	if use doc ; then
		doman ${PN}.1
	fi

	if use qt6 ; then
		insinto /usr/share/pixmaps
		doins gui/cppcheck-gui.png

		insinto /usr/share/Cppcheck/help
		doins gui/help/online-help.qhc
		doins gui/help/online-help.qch
	fi

	if use htmlreport ; then
		dobin htmlreport/cppcheck-htmlreport
	fi

	dodoc -r tools/triage
}
