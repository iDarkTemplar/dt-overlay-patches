# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop qt6-build-extra xdg-utils

DESCRIPTION="Various Qt6 tools, including assistant, designer, linguist, qdoc and others"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE="+assistant +designer +distancefieldgenerator +linguist +pixeltool
	+qdbus +qdoc +qtattributionsscanner +qtdiag +qtplugininfo
	doc examples"
REQUIRED_USE="linguist? ( designer )"

DEPEND="
	~dev-qt/qtbase-${PV}:6=[gui,network,png]
	assistant? ( ~dev-qt/qtbase-${PV}:6=[sql,widgets] )
	designer? ( ~dev-qt/qtbase-${PV}:6=[widgets] )
	distancefieldgenerator? (
		~dev-qt/qtbase-${PV}:6=[widgets]
		~dev-qt/qtdeclarative-${PV}:6=[widgets]
	)
	pixeltool? ( ~dev-qt/qtbase-${PV}:6=[widgets] )
	qdbus? ( ~dev-qt/qtbase-${PV}:6=[dbus,widgets] )
	qdoc? (
		~dev-qt/qtdeclarative-${PV}:6=[widgets]
		sys-devel/clang:=
	)
	qtdiag? ( ~dev-qt/qtbase-${PV}:6=[opengl,widgets] )
"

RDEPEND="${DEPEND}"

PDEPEND="
	doc? ( ~dev-qt/qttools-doc-${PV} )
"

src_configure() {
	local mycmakeargs=(
		# exclude examples and tests from default build
		-DQT_BUILD_EXAMPLES=$(usex examples ON OFF)
		-DQT_BUILD_TESTS=OFF

		$(qt_feature assistant)
		-DQT_FEATURE_commandlineparser=ON
		$(qt_feature designer)
		$(qt_feature distancefieldgenerator)
		$(qt_feature linguist)
		$(qt_feature pixeltool)
		$(qt_feature qdbus)
		$(qt_feature qdoc clang)
		$(qt_feature qtattributionsscanner)
		$(qt_feature qtdiag)
		$(qt_feature qtplugininfo)
		-DQT_FEATURE_thread=ON
	)

	qt6-build_src_configure
}

src_install() {
	if use examples; then
		qt_install_example_sources examples
	fi

	cmake_src_install

	qt_install_bin_symlinks

	if use assistant; then
		newicon -s 32 src/assistant/assistant/images/assistant.png assistant-qt6.png
		newicon -s 128 src/assistant/assistant/images/assistant-128.png assistant-qt6.png
		make_desktop_entry "${QT6_BINDIR}"/assistant 'Qt 6 Assistant' assistant-qt6 'Qt;Development;Documentation' Comment="Tool for viewing on-line documentation in Qt help file format"
	fi

	if use designer; then
		newicon -s 128 src/designer/src/designer/images/designer.png designer-qt6.png
		make_desktop_entry "${QT6_BINDIR}"/designer 'Qt 6 Designer' designer-qt6 'Qt;Development;GUIDesigner' Comment="WYSIWYG tool for designing and building graphical user interfaces with QtWidgets"
	fi

	if use linguist; then
		local size
		for size in 16 32 48 64 128; do
			newicon -s ${size} src/linguist/linguist/images/icons/linguist-${size}-32.png linguist-qt6.png
		done
		make_desktop_entry "${QT6_BINDIR}"/linguist 'Qt 6 Linguist' linguist-qt6 'Qt;Development;Translation' Comment="Graphical tool for translating Qt applications"
	fi

	if use qdbus; then
		newicon -s 32 src/qdbus/qdbusviewer/images/qdbusviewer.png qdbusviewer-qt6.png
		newicon -s 128 src/qdbus/qdbusviewer/images/qdbusviewer-128.png qdbusviewer-qt6.png
		make_desktop_entry "${QT6_BINDIR}"/qdbusviewer 'Qt 6 QDBusViewer' qdbusviewer-qt6 'Qt;Development' Comment="Graphical tool that lets you introspect D-Bus objects and messages"
	fi

	if stat "${ED}/usr/share/applications/"*.desktop &>/dev/null ; then
		# Hack: remove hardcoded original comment
		sed -i -e "/Comment=Various Qt6 tools, including assistant, designer, linguist, qdoc and others/d" "${ED}/usr/share/applications/"*.desktop
	fi
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
