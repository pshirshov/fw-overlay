# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI="4"
inherit eutils versionator

SLOT="0"
RDEPEND=">=virtual/jdk-1.6"

RESTRICT="strip mirror"
QA_TEXTRELS="opt/${P}/bin/libbreakgen.so"

DESCRIPTION="The intelligent cross-platform C/C++ IDE"
HOMEPAGE="https://www.jetbrains.com/clion/"

VER=($(get_all_version_components))
SRC_URI="http://download.jetbrains.com/cpp/${PN}-${PV}.tar.gz"

LICENSE="CLion-IDEA"
IUSE=""
KEYWORDS="~x86 ~amd64"

S="${WORKDIR}/${PN}-${PV}"

src_install() {
	local dir="/opt/${P}"
	local exe="${PN}"

	insinto "${dir}"
	doins -r *

	fperms 755 "${dir}/bin/gdb/bin/gdb"
	fperms 755 "${dir}/bin/${PN}.sh"
	fperms 755 "${dir}/bin/inspect.sh"
	fperms 755 "${dir}/bin/fsnotifier64"
	fperms 755 "${dir}/bin/fsnotifier"
	fperms 755 "${dir}/bin/cmake/bin/cmake"

	newicon "bin/${PN}.svg" "${exe}.svg"
	make_wrapper "${exe}" "/opt/${P}/bin/${PN}.sh"
	make_desktop_entry ${exe} "CLion IDE ${PV}" "${exe}" "Development;IDE"
}
