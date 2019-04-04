# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Crystal SVG icon theme"
HOMEPAGE="https://trinitydesktop.org/"
SRC_URI="https://mirror.git.trinitydesktop.org/cgit/tdelibs/snapshot/tdelibs-r${PV}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

RESTRICT="strip binchecks"

S="${WORKDIR}/tdelibs-r${PV}"

src_install() {
	local size group name sizestring groupname
	local themedir=/usr/share/icons/crystalsvg

	cd pics
	dodoc LICENSE.crystalsvg

	cd crystalsvg

	for file in *.png *.svg* ; do
		size=$(echo ${file:2} | cut -d - -f 1)
		group=$(echo $file | cut -d - -f 2)
		name=$(echo $file | cut -d - -f 3-)

		if [ "$size" = "sc" ] ; then
			sizestring="scalable"
		else
			sizestring="${size}x${size}"
		fi

		if [ "${group}" = "mime" ] ; then
			groupname="mimetypes"
		elif [ "${group}" = "filesys" ] ; then
			groupname="filesystems"
		elif [ "${group}" = "device" ] ; then
			groupname="devices"
		elif [ "${group}" = "app" ] ; then
			groupname="apps"
		elif [ "${group}" = "action" ] ; then
			groupname="actions"
		else
			groupname="${group}"
		fi

		if [ "$sizestring" != "x" ] && [ -n "$groupname" ] && [ -n "$name" ] ; then
			insinto ${themedir}/${sizestring}/${groupname}
			newins ${file} ${name}
		fi
	done

	insinto ${themedir}
	doins index.theme
}
