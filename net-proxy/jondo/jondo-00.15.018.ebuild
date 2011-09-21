# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

SLOT="$(get_major_version)"
RDEPEND=">=virtual/jdk-1.6"

#MY_PV="$(get_version_component_range 4-5)"

RESTRICT="strip"
#QA_TEXTRELS="opt/${P}/bin/libbreakgen.so"

DESCRIPTION="JonDo, formerly JAP, is the ip changer proxy tool"
HOMEPAGE="http://anonymous-proxy-servers.net/en/jondo.html"
SRC_URI="http://anonymous-proxy-servers.net/downloads/jondo_linux.tar.bz2"
LICENSE="jap"
IUSE=""
KEYWORDS="~x86 ~amd64"

pkg_postinst() {
    local dir="/opt/${PN}"
    local wrapper="${dir}/${PN}.sh"
    touch ${wrapper}
    echo "#!/bin/sh" > ${wrapper}         
    echo "java -jar JAP.jar" >> ${wrapper}
    chmod 755 ${wrapper}
}

src_install() {
    local dir="/opt/${PN}"
    insinto "${dir}"
    doins -r *
    
    newicon "jondo_linux/icons/${PN}-32.png" "${PN}.png"
    make_wrapper "${PN}" "${dir}/${PN}.sh"
    make_desktop_entry "${PN}" "JAP/JonDo" "${PN}" "Network;Proxy"
}

