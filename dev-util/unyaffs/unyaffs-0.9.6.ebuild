# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=4
inherit versionator eutils

DESCRIPTION="Unyaffs is a program to extract files from a YAFFS2 file system image"
HOMEPAGE="https://github.com/ehlers/unyaffs"
SRC_URI="https://github.com/ehlers/unyaffs/archive/${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* x86 amd64"
RESTRICT="mirror"

S="${WORKDIR}/${PN}-${PV}"

src_install() {
	dobin ${PN} || die
}
