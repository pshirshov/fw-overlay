# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit versionator

REL=$(get_version_component_range 1-2)
SHORTREL=${REL/#20/}

DESCRIPTION="Command line tool for Perforce version control system"
HOMEPAGE="http://www.perforce.com/"
SRC_URI="x86? ( ftp://ftp.perforce.com/perforce/r${SHORTREL}/bin.linux26x86/p4 \
	-> ${PF}-x86 )
	amd64? ( ftp://ftp.perforce.com/perforce/r${SHORTREL}/bin.linux26x86_64/p4 \
	-> ${PF}-amd64 )"

LICENSE="perforce"
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
IUSE=""
RESTRICT="mirror strip"

S=${WORKDIR}

src_unpack() {
	# we have to copy all of the files from $DISTDIR, otherwise we get
	# sandbox violations when trying to install

	cp ${DISTDIR}/${A} p4
}

src_install() {
	dobin p4 || die
}
