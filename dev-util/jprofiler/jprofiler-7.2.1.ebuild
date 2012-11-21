# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

SLOT="$(get_major_version)"
RDEPEND=">=virtual/jdk-1.6"

RESTRICT="strip"

DESCRIPTION="JProfiler java profiling tool"
HOMEPAGE="http://www.ej-technologies.com/products/jprofiler/overview.html"
SRC_URI="http://download-aws.ej-technologies.com/jprofiler/jprofiler_linux_7_2_1.tar.gz"
LICENSE="jprofiler"
IUSE=""
KEYWORDS="~x86 ~amd64"

pkg_postinst() {
    local dir="/opt/${PN}"
    local wrapper="${dir}/${PN}.sh"
    touch ${wrapper}
    echo "#!/bin/sh" > ${wrapper}         
    echo "cd ${dir}/jprofiler7/bin" >> ${wrapper}
    echo "java -jar jprofiler.jar" >> ${wrapper}
    chmod 755 ${wrapper}
}

src_install() {
    local dir="/opt/${PN}"
    insinto "${dir}"
    doins -r *
    
    newicon "jprofiler7/.install4j/i4j_extf_5_198c2a3_2q92zr.ico" "${PN}.ico"
    make_wrapper "${PN}" "${dir}/${PN}.sh"
    make_desktop_entry "${PN}" "JProfiler" "${PN}" "Development;Profiler"
}

