# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: qt6-build-extra.eclass
# @MAINTAINER:
# darktemplar@dark-templar-archives.net
# @AUTHOR:
# i.Dark_Templar <darktemplar@dark-templar-archives.net>
# @SUPPORTED_EAPIS: 8
# @BLURB: Eclass for Qt6 split ebuilds.
# @DESCRIPTION:
# This eclass contains various functions that are used when building Qt6.
# Requires EAPI 8.

if [[ ${CATEGORY} != dev-qt ]]; then
	die "qt6-build-extra.eclass is only to be used for building Qt 6"
fi

case ${EAPI} in
	8) ;;
	*)	die "qt6-build-extra.eclass: unsupported EAPI=${EAPI:-0}" ;;
esac

inherit qt6-build

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

# @FUNCTION: qt_install_example_sources
#
# This function installs example sources
qt_install_example_sources() {
	local exampledir
	local installexampledir

	local inputdir=$1
	local stripdir=$2

	if [ -z "${stripdir}" ] ; then
		stripdir="${inputdir}"
	fi

	if [ -z "${QT6_EXAMPLESDIR}" ] ; then
		die "QT6_EXAMPLESDIR is not defined"
	fi

	# QTBUG-86302: install example sources manually
	while read exampledir ; do
		exampledir="$(dirname "$exampledir")"
		installexampledir="$(dirname "$exampledir")"
		installexampledir="${installexampledir#${stripdir}/}"
		insinto "${QT6_EXAMPLESDIR}/${installexampledir}"
		doins -r "${exampledir}"
	done < <(find "${1}" -name CMakeLists.txt 2>/dev/null | xargs grep -l -i project)
}

# @FUNCTION: qt_install_docs
#
# This function installs documentation
qt_install_docs() {
	DESTDIR="${D}" cmake_build install_docs
}
