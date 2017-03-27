EAPI="2"

inherit autotools qt4-r2 git-2

DESCRIPTION="Heilmall Suite"
HOMEPAGE="https://github.com/Benjamin-Dobell/Heimdall/"
EGIT_REPO_URI="git://github.com/Benjamin-Dobell/Heimdall.git"
EGIT_COMMIT="v1.4.1RC2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE="qt4"

DEPEND="virtual/libc
	virtual/libusb
	qt4? ( >=dev-qt/qtgui-4.7 )"

RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_prepare() {
	if use qt4 ; then
		epatch "${FILESDIR}/heimdall-qt4-installdir.patch"
	fi
}

src_configure() {
	cd "${S}/libpit"
	econf

	cd "${S}/heimdall"
	econf

	if use qt4 ; then
		cd "${S}/heimdall-frontend"
		eqmake4 "heimdall-frontend.pro" OUTPUTDIR=/usr/bin
	fi
}

src_compile() {
	cd "${S}/libpit"
	emake || die "emake failed"

	cd "${S}/heimdall"
	emake || die "emake failed"

	if use qt4 ; then
		cd "${S}/heimdall-frontend"
		emake || die "emake failed"
	fi
}

src_install() {
	cd "${S}/heimdall"
	emake DESTDIR="${D}" install || die "emake install failed"

	if use qt4 ; then
		cd "${S}/heimdall-frontend"
		emake INSTALL_ROOT="${D}" install || die "emake install failed"
	fi
}
