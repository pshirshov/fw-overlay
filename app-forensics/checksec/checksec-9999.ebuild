# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
SRC_URI="http://www.trapkit.de/tools/${PN}.sh"
SLOT="0"

RESTRICT="mirror"
DESCRIPTION="The checksec.sh script is designed to test what standard Linux OS and PaX security features are being used"
HOMEPAGE="http://www.trapkit.de/tools/checksec.html"
RDEPEND="sys-devel/binutils"
KEYWORDS="~x86 ~amd64"

S="${WORKDIR}"

src_unpack() {
    cp "${DISTDIR}/${PN}.sh" "${WORKDIR}"
}

src_install() {
    newbin ${PN}.sh unfoo || die
}
