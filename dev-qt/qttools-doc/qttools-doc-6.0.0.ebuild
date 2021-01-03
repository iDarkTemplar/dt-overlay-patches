# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QT6_MODULE="qttools"
inherit cmake qt6-build

DESCRIPTION="Documentation for various Qt6 tools, including assistant, designer, linguist, qdoc and others"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
fi

IUSE="dbus examples qml"
# TODO: example sources

BDEPEND="
	~dev-qt/qttools-${PV}:6=
	"

DEPEND="
	~dev-qt/qttools-${PV}:6=[dbus=,examples=,qml=]
	!dev-qt/qt-docs
"

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
	cmake_src_compile docs
}

src_install() {
	DESTDIR="${D}" cmake_src_compile install_docs
}
