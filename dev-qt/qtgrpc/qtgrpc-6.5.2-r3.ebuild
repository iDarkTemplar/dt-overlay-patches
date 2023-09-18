# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qt6-build

DESCRIPTION="Qt GRPC and Protobuf generator and bindings for the Qt6 framework"

if [[ ${QT6_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 arm arm64 ppc64 ~riscv x86"
fi

IUSE=""

DEPEND="
	~dev-qt/qtbase-${PV}:6=[gui,network,widgets]
	~dev-qt/qtdeclarative-${PV}:6=
	dev-libs/protobuf:=
	net-libs/grpc:=
"
RDEPEND="${DEPEND}"
