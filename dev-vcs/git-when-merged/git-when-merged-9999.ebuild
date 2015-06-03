# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit eutils versionator git-r3

DESCRIPTION="Find when a commit was merged into one or more branches."
HOMEPAGE="https://github.com/mhagger/git-when-merged"
EGIT_REPO_URI="https://github.com/mhagger/git-when-merged"

if [[ ${PV} == 9999* ]] ; then
    KEYWORDS="-*"
else
    # second version comonent is a ebuild sequential number, third version
    # component is a dec-encoded 8 hex digits of commit hash
    EGIT_COMMIT="$(printf "%08x" $(get_version_component_range 3))"
    KEYWORDS="amd64 x86"
fi

LICENSE="GPL-2"
SLOT="0"
RESTRICT="mirror"
IUSE=""

DEPEND=""
RDEPEND=">=dev-vcs/git-2.3.6"

INSTALL_DIR=/usr/libexec/git-core/

src_install() {
    insinto "${INSTALL_DIR}"
    doins bin/${PN} || die
    fperms 755 ${INSTALL_DIR}/${PN}
}
