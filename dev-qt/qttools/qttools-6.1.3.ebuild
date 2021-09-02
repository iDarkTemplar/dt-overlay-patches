# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QT6_MODULE="qttools"
inherit cmake desktop qt6-build xdg-utils

DESCRIPTION="Various Qt6 tools, including assistant, designer, linguist, qdoc and others"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE="dbus doc examples qml"

DEPEND="
	~dev-qt/qtbase-${PV}:6=[gui,network,opengl,png,sql,widgets]
	sys-devel/clang:=
	dbus? ( ~dev-qt/qtbase-${PV}:6=[dbus] )
	qml? ( ~dev-qt/qtdeclarative-${PV}:6=[widgets] )
	doc? (
		!dev-qt/qt-docs:6
		!dev-qt/qttools-doc:6
	)
"

RDEPEND="${DEPEND}"

src_prepare() {
	qt_use_disable_target dbus Qt::DBus \
		src/CMakeLists.txt

	qt_use_disable_target qml Qt::Quick \
		src/CMakeLists.txt

	qt_use_disable_target qml Qt::QuickWidgets \
		src/designer/src/plugins/CMakeLists.txt

	qt_use_disable_target qml Qt::QmlDevToolsPrivate \
		src/qdoc/CMakeLists.txt \
		src/linguist/lupdate/CMakeLists.txt

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs

	qt6_prepare_env

	# bug 633838
	unset QMAKESPEC XQMAKESPEC QMAKEPATH QMAKEFEATURES

	mycmakeargs=(
		# exclude examples and tests from default build
		-DQT_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DQT_BUILD_TESTS=OFF
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc; then
		cmake_src_compile docs
	fi
}

src_install() {
	local exampledir
	local installexampledir

	if use examples; then
		# QTBUG-86302: install example sources manually
		while read exampledir ; do
			exampledir="$(dirname "$exampledir")"
			installexampledir="$(dirname "$exampledir")"
			installexampledir="${installexampledir#examples/}"
			insinto "${QT6_EXAMPLESDIR}/${installexampledir}"
			doins -r "${exampledir}"
		done < <(find examples -name CMakeLists.txt 2>/dev/null | xargs grep -l -i project)
	fi

	cmake_src_install $(usex doc install_docs "")

	qt_install_bin_symlinks

	newicon -s 32 src/assistant/assistant/images/assistant.png assistant-qt6.png
	newicon -s 128 src/assistant/assistant/images/assistant-128.png assistant-qt6.png
	make_desktop_entry "${QT6_BINDIR}"/assistant 'Qt 6 Assistant' assistant-qt6 'Qt;Development;Documentation' Comment="Tool for viewing on-line documentation in Qt help file format"

	newicon -s 128 src/designer/src/designer/images/designer.png designer-qt6.png
	make_desktop_entry "${QT6_BINDIR}"/designer 'Qt 6 Designer' designer-qt6 'Qt;Development;GUIDesigner' Comment="WYSIWYG tool for designing and building graphical user interfaces with QtWidgets"

	local size
	for size in 16 32 48 64 128; do
		newicon -s ${size} src/linguist/linguist/images/icons/linguist-${size}-32.png linguist-qt6.png
	done
	make_desktop_entry "${QT6_BINDIR}"/linguist 'Qt 6 Linguist' linguist-qt6 'Qt;Development;Translation' Comment="Graphical tool for translating Qt applications"

	if use dbus; then
		newicon -s 32 src/qdbus/qdbusviewer/images/qdbusviewer.png qdbusviewer-qt6.png
		newicon -s 128 src/qdbus/qdbusviewer/images/qdbusviewer-128.png qdbusviewer-qt6.png
		make_desktop_entry "${QT6_BINDIR}"/qdbusviewer 'Qt 6 QDBusViewer' qdbusviewer-qt6 'Qt;Development' Comment="Graphical tool that lets you introspect D-Bus objects and messages"
	fi

	# Hack: remove hardcoded original comment
	sed -i -e "/Comment=Various Qt6 tools, including assistant, designer, linguist, qdoc and others/d" "${ED}/usr/share/applications/"*.desktop
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
