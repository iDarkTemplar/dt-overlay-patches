# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KDE_ORG_COMMIT=29ee9a0e9f02ec74153a2cf09dc63722bc273544
QT5_MODULE="qtdeclarative"
inherit qt5-build

DESCRIPTION="Documentation for the QML and Quick modules for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv x86"
fi

IUSE="vulkan"

DEPEND="
	=dev-qt/qtdeclarative-${QT5_PV}*[vulkan?]
	=dev-qt/qdoc-${QT5_PV}*[qml]
	=dev-qt/qtattributionsscanner-${QT5_PV}*
	=dev-qt/qthelp-${QT5_PV}*
	!dev-qt/qt-docs:5
"
RDEPEND="${DEPEND}"

src_configure() {
	local myqmakeargs=(
		--
		-qml-debug
	)
	qt5-build_src_configure
}

src_compile() {
	qt5_foreach_target_subdir emake docs
}

src_install() {
	qt5_foreach_target_subdir emake INSTALL_ROOT="${D}" install_docs
}
