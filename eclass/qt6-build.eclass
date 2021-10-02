# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: qt6-build.eclass
# @MAINTAINER:
# darktemplar@dark-templar-archives.net
# @AUTHOR:
# i.Dark_Templar <darktemplar@dark-templar-archives.net>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Eclass for Qt6 split ebuilds.
# @DESCRIPTION:
# This eclass contains various functions that are used when building Qt6.
# Requires EAPI 7.

if [[ ${CATEGORY} != dev-qt ]]; then
	die "qt6-build.eclass is only to be used for building Qt 6"
fi

case ${EAPI} in
	7) inherit eapi8-dosym ;;
	8) ;;
	*)	die "qt6-build.eclass: unsupported EAPI=${EAPI:-0}" ;;
esac

inherit toolchain-funcs

# @ECLASS-VARIABLE: QT6_MODULE
# @PRE_INHERIT
# @DESCRIPTION:
# The upstream name of the module this package belongs to. Used for
# SRC_URI and EGIT_REPO_URI. Must be set before inheriting the eclass.
: ${QT6_MODULE:=${PN}}

HOMEPAGE="https://www.qt.io/"
LICENSE="|| ( GPL-2 GPL-3 LGPL-3 ) FDL-1.3"
SLOT=6/$(ver_cut 1-2)

QT6_MINOR_VERSION=$(ver_cut 2)
readonly QT6_MINOR_VERSION

case ${PV} in
	6.9999)
		# git dev branch
		QT6_BUILD_TYPE="live"
		EGIT_BRANCH="dev"
		;;
	6.?.9999|6.??.9999|6.???.9999)
		# git stable branch
		QT6_BUILD_TYPE="live"
		EGIT_BRANCH=${PV%.9999}
		;;
	*_alpha*|*_beta*|*_rc*)
		# development release
		QT6_BUILD_TYPE="release"
		MY_P=${QT6_MODULE}-everywhere-src-${PV/_/-}
		SRC_URI="https://download.qt.io/development_releases/qt/${PV%.*}/${PV/_/-}/submodules/${MY_P}.tar.xz"
		S=${WORKDIR}/${MY_P}
		;;
	*)
		# official stable release
		QT6_BUILD_TYPE="release"
		MY_P=${QT6_MODULE}-everywhere-src-${PV}
		SRC_URI="https://download.qt.io/official_releases/qt/${PV%.*}/${PV}/submodules/${MY_P}.tar.xz"
		S=${WORKDIR}/${MY_P}
		;;
esac
readonly QT6_BUILD_TYPE

EGIT_REPO_URI=(
	"https://code.qt.io/qt/${QT6_MODULE}.git"
	"https://github.com/qt/${QT6_MODULE}.git"
)
[[ ${QT6_BUILD_TYPE} == live ]] && inherit git-r3

BDEPEND="
	virtual/pkgconfig
	app-arch/libarchive[zstd(-)]
	>=dev-util/cmake-3.18
	"

# @FUNCTION: qt6_prepare_env
# @INTERNAL
# @DESCRIPTION:
# Prepares the environment for building Qt.
qt6_prepare_env() {
	# setup installation directories
	# note: keep paths in sync with qmake-utils.eclass
	QT6_PREFIX=${EPREFIX}/usr
	QT6_HEADERDIR=${QT6_PREFIX}/include/qt6
	QT6_LIBDIR=${QT6_PREFIX}/$(get_libdir)
	QT6_ARCHDATADIR=${QT6_PREFIX}/$(get_libdir)/qt6
	QT6_BINDIR=${QT6_ARCHDATADIR}/bin
	QT6_PLUGINDIR=${QT6_ARCHDATADIR}/plugins
	QT6_LIBEXECDIR=${QT6_ARCHDATADIR}/libexec
	QT6_IMPORTDIR=${QT6_ARCHDATADIR}/imports
	QT6_QMLDIR=${QT6_ARCHDATADIR}/qml
	QT6_MKSPECSDIR=${QT6_ARCHDATADIR}/mkspecs
	QT6_DATADIR=${QT6_PREFIX}/share/qt6
	QT6_DOCDIR=${QT6_PREFIX}/share/qt6-doc
	QT6_TRANSLATIONDIR=${QT6_DATADIR}/translations
	QT6_EXAMPLESDIR=${QT6_DATADIR}/examples
	QT6_TESTSDIR=${QT6_DATADIR}/tests
	QT6_SYSCONFDIR=${EPREFIX}/etc/xdg
	readonly QT6_PREFIX QT6_HEADERDIR QT6_LIBDIR QT6_ARCHDATADIR \
		QT6_BINDIR QT6_PLUGINDIR QT6_LIBEXECDIR QT6_IMPORTDIR \
		QT6_QMLDIR QT6_MKSPECSDIR QT6_DATADIR QT6_DOCDIR QT6_TRANSLATIONDIR \
		QT6_EXAMPLESDIR QT6_TESTSDIR QT6_SYSCONFDIR
}

# @FUNCTION: eqmake6
# @USAGE: [arguments for qmake]
# @DESCRIPTION:
# Wrapper for Qt6's qmake. All arguments are passed to qmake.
#
# For recursive build systems, i.e. those based on the subdirs template,
# you should run eqmake5 on the top-level project file only, unless you
# have a valid reason to do otherwise. During the building, qmake will
# be automatically re-invoked with the right arguments on every directory
# specified inside the top-level project file.
eqmake6() {
	debug-print-function ${FUNCNAME} "$@"

	ebegin "Running qmake"

	"${QT6_BINDIR}"/qmake \
		-makefile \
		QMAKE_AR="$(tc-getAR) cqs" \
		QMAKE_CC="$(tc-getCC)" \
		QMAKE_LINK_C="$(tc-getCC)" \
		QMAKE_LINK_C_SHLIB="$(tc-getCC)" \
		QMAKE_CXX="$(tc-getCXX)" \
		QMAKE_LINK="$(tc-getCXX)" \
		QMAKE_LINK_SHLIB="$(tc-getCXX)" \
		QMAKE_OBJCOPY="$(tc-getOBJCOPY)" \
		QMAKE_RANLIB= \
		QMAKE_STRIP= \
		QMAKE_CFLAGS="${CFLAGS}" \
		QMAKE_CFLAGS_RELEASE= \
		QMAKE_CFLAGS_DEBUG= \
		QMAKE_CXXFLAGS="${CXXFLAGS}" \
		QMAKE_CXXFLAGS_RELEASE= \
		QMAKE_CXXFLAGS_DEBUG= \
		QMAKE_LFLAGS="${LDFLAGS}" \
		QMAKE_LFLAGS_RELEASE= \
		QMAKE_LFLAGS_DEBUG= \
		"$@"

	if ! eend $? ; then
		echo
		eerror "Running qmake has failed! (see above for details)"
		eerror "This shouldn't happen - please send a bug report to https://bugs.gentoo.org/"
		echo
		die "eqmake6 failed"
	fi
}

eqmake6_configure() {
	debug-print-function ${FUNCNAME} "$@"

	mkdir -p "${S}_build"

	pushd "${S}_build" > /dev/null || die
	eqmake6 "$@" "${S}"
	popd > /dev/null || die
}

eqmake6_compile() {
	debug-print-function ${FUNCNAME} "$@"

	pushd "${S}_build" > /dev/null || die
	emake VERBOSE=1 "$@"
	popd > /dev/null || die
}

eqmake6_install() {
	debug-print-function ${FUNCNAME} "$@"

	pushd "${S}_build" > /dev/null || die
	emake VERBOSE=1 INSTALL_ROOT="${ED}" install
	popd > /dev/null || die
}

# @FUNCTION: qt_use_disable_target
# @USAGE: <flag> <target> <files...>
# @DESCRIPTION:
# <flag> is the name of a flag in IUSE.
# <target> is the (lowercase) name of a cmake target.
# <files...> is a list of one or more qmake project files.
#
# This function patches <files> to treat <target> as not installed
# when <flag> is disabled, otherwise it does nothing.
# This can be useful to avoid an automagic dependency when the target
# is present on the system but the corresponding USE flag is disabled.
qt_use_disable_target() {
	[[ $# -ge 3 ]] || die "${FUNCNAME}() requires at least three arguments"

	local flag=$1
	local target=$2
	shift 2

	if ! use "${flag}"; then
		echo "$@" | xargs sed -i -e "s/TARGET ${target}/FALSE/g" || die
	fi
}


# @FUNCTION: qt_install_bin_symlinks
#
# This function installs suffixed symlinks for all qt6 binaries into /usr/bin
qt_install_bin_symlinks() {
	local binary

	if [ -d "${D}/${QT6_BINDIR}" ] ; then
		for binary in "${D}/${QT6_BINDIR}"/* ; do
			case ${EAPI} in
				7)
					dosym8 -r "${QT6_BINDIR#${EPREFIX}}"/$(basename ${binary}) /usr/bin/$(basename ${binary})-qt6
					;;
				8)
					dosym -r "${QT6_BINDIR#${EPREFIX}}"/$(basename ${binary}) /usr/bin/$(basename ${binary})-qt6
					;;
			esac
		done
	fi
}
