# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/keepassx/keepassx-0.4.3.ebuild,v 1.8 2013/03/02 19:06:31 hwoarang Exp $

EAPI=5
inherit qt4-r2 eutils cmake-utils multilib

DESCRIPTION="Qt password manager compatible with its Win32 and Pocket PC versions"
HOMEPAGE="http://www.keepassx.org/dev"

if [[ ${PV} != 9999* ]] ; then
    SRC_URI="https://github.com/keepassx/keepassx/archive/${PV/_/-}.tar.gz -> ${P}.tar.gz"
    S="${WORKDIR}/${P/_/-}"
    KEYWORDS="**"
else
    inherit git-2
    EGIT_REPO_URI="https://github.com/keepassx/keepassx"
    KEYWORDS="**"
fi

LICENSE="GPL-2"
SLOT="0"

IUSE="debug pch"

DEPEND=">=dev-libs/libgcrypt-1.5.0-r2
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtdbus:4
	dev-qt/qttest:4
	dev-qt/qtxmlpatterns:4
	|| ( >=x11-libs/libXtst-1.1.0 <x11-proto/xextproto-7.1.0 )"
RDEPEND="${DEPEND}"

RESTRICT="nomirror"


src_prepare() {
    sed -e "s|PLUGIN_INSTALL_DIR \"lib/keepassx\"|PLUGIN_INSTALL_DIR \"$(get_libdir)/keepassx\"|" \
        -i CMakeLists.txt || die
}

src_configure() {
        mycmakeargs=(
                -DCMAKE_BUILD_TYPE=Release
        )
        cmake-utils_src_configure
}

src_install() {
        cmake-utils_src_install

        newicon "${S}"/share/icons/application/scalable/apps/keepassx.svgz keepassx.svgz
        #make_desktop_entry keepassx "KeepassX" keepassx
}
