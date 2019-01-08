EAPI=6

DESCRIPTION="Virtual package owning ParserDetails.ini for XML::SAX-related perl modules"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sparc x86 ~ppc-aix ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="dev-lang/perl:="
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install() {
	local filename="$(perl -e \
		'use XML::SAX;
		use File::Basename qw(dirname);
		use File::Spec ();
		my $dir = $INC{"XML/SAX.pm"};
		$dir = dirname($dir);
		my $filename = File::Spec->catfile($dir, "SAX", XML::SAX::PARSER_DETAILS);
		print $filename;'
	)"

	dodir "$(dirname ${filename})"
	touch "${ED}${filename}"
}
