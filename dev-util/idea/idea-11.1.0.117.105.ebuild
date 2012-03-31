# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI="4"
inherit eutils versionator

SLOT="$(get_major_version)"
RDEPEND=">=virtual/jdk-1.6"

RESTRICT="strip"
QA_TEXTRELS="opt/${P}/bin/libbreakgen.so"

DESCRIPTION="IntelliJ IDEA is an intelligent Java IDE"
HOMEPAGE="http://jetbrains.com/idea/"
SRC_URI="http://download.jetbrains.com/${PN}/${PN}IU-$(get_version_component_range 1-2).tar.gz"
LICENSE="IntelliJ-IDEA"
IUSE=""
KEYWORDS="~x86 ~amd64"
MY_PV="$(get_version_component_range 4-5)"
S="${WORKDIR}/${PN}-IU-${MY_PV}"

src_install() {
	local dir="/opt/${P}"
	local exe="${PN}-${SLOT}"

	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}/bin/${PN}.sh"
	fperms 755 "${dir}/bin/fsnotifier"
	fperms 755 "${dir}/bin/fsnotifier64"

	newicon "bin/${PN}.png" "${exe}.png"
	make_wrapper "${exe}" "/opt/${P}/bin/${PN}.sh"
	make_desktop_entry ${exe} "IntelliJ IDEA ${PV}" "${exe}" "Development;IDE"
}

