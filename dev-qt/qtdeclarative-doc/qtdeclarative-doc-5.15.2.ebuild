# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QT5_MODULE="qtdeclarative"
inherit qt5-build

DESCRIPTION="Documentation for the QML and Quick modules for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 x86"
fi

IUSE="vulkan"

DEPEND="
	~dev-qt/qtdeclarative-${PV}[vulkan?]
	~dev-qt/qdoc-${PV}[qml]
	~dev-qt/qtattributionsscanner-${PV}
	~dev-qt/qthelp-${PV}
	!dev-qt/qt-docs
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
