# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
LLVM_MAX_SLOT=14
PLOCALES="cs da de fr hr ja pl ru sl uk zh-CN zh-TW"

inherit llvm cmake qt6-build virtualx xdg

DESCRIPTION="Lightweight IDE for C++/QML development centering around Qt"
HOMEPAGE="https://doc.qt.io/qtcreator/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://code.qt.io/${PN}/${PN}.git"
else
	MY_PV=${PV/_/-}
	MY_P=${PN}-opensource-src-${MY_PV}
	[[ ${MY_PV} == ${PV} ]] && MY_REL=official || MY_REL=development
	SRC_URI="https://download.qt.io/${MY_REL}_releases/${PN/-}/$(ver_cut 1-2)/${MY_PV}/${MY_P}.tar.xz"
	S=${WORKDIR}/${MY_P}
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
QTC_PLUGINS=(android +autotest autotools:autotoolsprojectmanager baremetal bazaar beautifier boot2qt
	'+clang:clangcodemodel|clangformat|clangpchmanager|clangrefactoring|clangtools' clearcase cmake:cmakeprojectmanager cppcheck
	ctfvisualizer cvs +designer git glsl:glsleditor +help lsp:languageclient mcu:mcusupport mercurial
	modeling:modeleditor nim perforce perfprofiler python qbs:qbsprojectmanager +qmldesigner
	+qmljs:qmljseditor qmlprofiler qnx remotelinux scxml:scxmleditor serialterminal silversearcher
	subversion valgrind webassembly)
IUSE="doc systemd test webengine ${QTC_PLUGINS[@]%:*}"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	boot2qt? ( remotelinux )
	clang? ( lsp test? ( qbs ) )
	mcu? ( cmake )
	python? ( lsp )
	qmldesigner? ( qmljs )
	qnx? ( remotelinux )
"

# minimum Qt version required
QT_PV="6.2.1:6"

BDEPEND="
	>=dev-qt/qttools-${QT_PV}
	virtual/pkgconfig
"
CDEPEND="
	>=dev-qt/qtbase-${QT_PV}[concurrent,gui,network,sql,ssl,widgets]
	>=dev-qt/qtdeclarative-${QT_PV}[widgets]
	>=dev-qt/qtsvg-${QT_PV}
	>=dev-qt/qt5compat-${QT_PV}
	clang? (
		>=dev-cpp/yaml-cpp-0.6.2:=
		|| (
			sys-devel/clang:14
			sys-devel/clang:13
			sys-devel/clang:12
		)
		<sys-devel/clang-$((LLVM_MAX_SLOT + 1)):=
	)
	designer? ( >=dev-qt/qttools-${QT_PV} )
	help? (
		>=dev-qt/qttools-${QT_PV}
		webengine? ( >=dev-qt/qtwebengine-${QT_PV}[widgets(+)] )
	)
	perfprofiler? ( dev-libs/elfutils )
	serialterminal? ( >=dev-qt/qtserialport-${QT_PV} )
	systemd? ( sys-apps/systemd:= )
"
DEPEND="${CDEPEND}
	test? ( >=dev-qt/qtdeclarative-${QT_PV}[localstorage] )
"
RDEPEND="${CDEPEND}
	sys-devel/gdb[python]
	autotools? ( sys-devel/autoconf )
	cmake? ( >=dev-util/cmake-3.14 )
	cppcheck? ( dev-util/cppcheck )
	cvs? ( dev-vcs/cvs )
	git? ( dev-vcs/git )
	mercurial? ( dev-vcs/mercurial )
	qbs? ( >=dev-util/qbs-1.18 )
	qmldesigner? ( >=dev-qt/qtquicktimeline-${QT_PV} )
	silversearcher? ( sys-apps/the_silver_searcher )
	subversion? ( dev-vcs/subversion )
	valgrind? ( dev-util/valgrind )
"
# qt translations must also be installed or qt-creator translations won't be loaded
for x in ${PLOCALES}; do
	IUSE+=" l10n_${x}"
	RDEPEND+=" l10n_${x}? ( >=dev-qt/qttranslations-${QT_PV} )"
done
unset x

llvm_check_deps() {
	has_version -d "sys-devel/clang:${LLVM_SLOT}"
}

pkg_setup() {
	use clang && llvm_pkg_setup
}

src_prepare() {
	default

	cmake_comment_add_subdirectory bin

	pushd src/plugins >/dev/null || die

	# disable unwanted plugins
	for plugin in "${QTC_PLUGINS[@]#[+-]}"; do
		if ! use ${plugin%:*}; then
			einfo "Disabling ${plugin%:*} plugin"
			cmake_comment_add_subdirectory "${plugin#*:}"
		fi
	done

	cmake_comment_add_subdirectory ios updateinfo winrt

	popd >/dev/null || die

	# avoid building unused support libraries and tools
	if ! use clang; then
		pushd src/libs >/dev/null || die
		cmake_comment_add_subdirectory clangsupport sqlite yaml-cpp
		popd >/dev/null || die

		pushd src/tools >/dev/null || die
		cmake_comment_add_subdirectory clangbackend pchmanagerbackend refactoringbackend
		popd >/dev/null || die
	fi
	if ! use glsl; then
		pushd src/libs >/dev/null || die
		cmake_comment_add_subdirectory glsl
		popd >/dev/null || die
	fi
	if ! use lsp; then
		pushd src/libs >/dev/null || die
		cmake_comment_add_subdirectory languageserverprotocol
		popd >/dev/null || die

		pushd tests/auto >/dev/null || die
		cmake_comment_add_subdirectory languageserverprotocol
		popd >/dev/null || die
	fi
	if ! use modeling; then
		pushd src/libs >/dev/null || die
		cmake_comment_add_subdirectory modelinglib
		popd >/dev/null || die
	fi
	if ! use perfprofiler; then
		rm -r src/tools/perfparser || die
		if ! use ctfvisualizer && ! use qmlprofiler; then
			pushd src/libs >/dev/null || die
			cmake_comment_add_subdirectory tracing
			popd >/dev/null || die

			pushd tests/auto >/dev/null || die
			cmake_comment_add_subdirectory tracing
			popd >/dev/null || die
		fi
	fi
	if ! use qmldesigner; then
		pushd src/libs >/dev/null || die
		cmake_comment_add_subdirectory advanceddockingsystem
		popd >/dev/null || die

		pushd src/tools >/dev/null || die
		cmake_comment_add_subdirectory qml2puppet
		popd >/dev/null || die

		pushd tests/auto/qml >/dev/null || die
		cmake_comment_add_subdirectory qmldesigner
		popd >/dev/null || die
	fi
	if ! use qmljs; then
		pushd src/libs >/dev/null || die
		cmake_comment_add_subdirectory qmleditorwidgets
		popd >/dev/null || die
	fi
	if ! use valgrind; then
		pushd src/tools >/dev/null || die
		cmake_comment_add_subdirectory valgrindfake
		popd >/dev/null || die

		pushd tests/auto >/dev/null || die
		cmake_comment_add_subdirectory valgrind
		popd >/dev/null || die
	fi

	# disable broken or unreliable tests
	pushd tests >/dev/null || die
	cmake_comment_add_subdirectory manual tools unit
	popd >/dev/null || die

	# fix translations
	local lang languages=
	for lang in ${PLOCALES}; do
		use l10n_${lang} && languages+=" ${lang/-/_}"
	done
	sed -i -e "/^set(languages\s*/s: .*): ${languages}):" share/qtcreator/translations/CMakeLists.txt || die

	# remove bundled yaml-cpp
	rm -r src/libs/3rdparty/yaml-cpp || die

	# remove bundled qbs
	rm -r src/shared/qbs || die

	# TODO: unbundle sqlite

	cmake_src_prepare
}

src_configure() {
	qt6_prepare_env

	local mycmakeargs=(
		-DBUILD_HELPVIEWERBACKEND_QTWEBENGINE=$(usex webengine)
		-DBUILD_TESTS_BY_DEFAULT=$(usex test)
		-DWITH_DOCS=$(usex doc)
		-DBUILD_DEVELOPER_DOCS=$(usex doc)
	)

	if use clang; then
		mycmakeargs+=(
			-DCMAKE_PREFIX_PATH="$(get_llvm_prefix ${LLVM_MAX_SLOT})"
		)
	fi

	if use qbs; then
		mycmakeargs+=(
			-DQBS_INSTALL_DIR="${EPREFIX}/usr"
		)
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc; then
		cmake_src_compile qch_docs
		cmake_src_compile html_docs
	fi
}

src_install() {
	cmake_src_install

	if use doc; then
		pushd "${BUILD_DIR}" > /dev/null || die

		# don't use ${PF} or the doc will not be found
		insinto /usr/share/doc/qtcreator
		doins -r doc/html
		docompress -x /usr/share/doc/qtcreator/html

		insinto /usr/share/doc/qtcreator
		doins share/doc/qtcreator/qtcreator{,-dev}.qch
		docompress -x /usr/share/doc/qtcreator/qtcreator{,-dev}.qch

		popd > /dev/null || die
	fi

	dodoc dist/{changes-*,known-issues}
}
