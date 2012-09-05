# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
inherit versionator eutils

REL=$(get_version_component_range 1-2)
SHORTREL=${REL/#20/}

DESCRIPTION="Perforce version control system server"
HOMEPAGE="http://www.perforce.com/"
SRC_URI="x86? ( ftp://ftp.perforce.com/perforce/r${SHORTREL}/bin.linux26x86/p4d \
			-> ${PF}-x86 )
	    amd64? (
		ftp://ftp.perforce.com/perforce/r${SHORTREL}/bin.linux26x86_64/p4d \
		    -> ${PF}-amd64 )"

LICENSE="perforce"
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
IUSE=""
RESTRICT="mirror strip"

S=${WORKDIR}

pkg_setup() {
	enewgroup perforce
	enewuser perforce -1 -1 /var/lib/perforce perforce
}

src_unpack() {

	cp ${DISTDIR}/${A} p4d
}

src_install() {
	dosbin p4d

	insinto /etc/conf.d
	newins ${FILESDIR}/p4d.confd p4d

	exeinto /etc/init.d
	newexe ${FILESDIR}/p4d.initd p4d

	dodir /var/lib/perforce || die
	fowners perforce:perforce /var/lib/perforce
}

pkg_postinst() {
	einfo
	einfo "Remember to edit the config file /etc/conf.d/p4d"
	einfo "By default, the journal file will be created in the same directory as"
	einfo "the database."
	einfo "We highly recommend moving it to a different hard disk"
	einfo
}
