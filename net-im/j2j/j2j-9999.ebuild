# Copyright Nikolaus Polak
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils multilib python subversion

DESCRIPTION="Jabber2Jabber Transport"
ESVN_REPO_URI="svn://svn.jrudevels.org/${PN}/trunk"
HOMEPAGE="http://wiki.jrudevels.org/index.php/Eng:J2J"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="pgsql mysql"

IUSE="postgres mysql"
RDEPEND=">=dev-lang/python-2.3
         >=dev-python/twisted-8.0.1
         >=dev-python/twisted-words-8.0.1
         >=dev-python/twisted-names-8.0.1
         postgres? ( >=dev-db/pygresql-3.8 )
         mysql? ( >=dev-db/mysql-4.1 )"

src_unpack() {
    subversion_src_unpack
}

src_install() {
    local inspath

    python_version
    inspath=/usr/$(get_libdir)/python${PYVER}/site-packages/${PN}
    insinto ${inspath}
    doins -r *

    insinto /etc/jabber

    sed -i \
        -e "s:/var/log/j2j/j2j.log:/var/log/jabber/j2j.log:" \
        -e "s:xml_logging=/var/log/j2j/xml.log:xml_logging=/var/log/jabber/j2j-xml.log:" \
        j2j.conf.example

    newins j2j.conf.example ${PN}.conf
    fperms 600 /etc/jabber/${PN}.conf
    fowners jabber:jabber /etc/jabber/${PN}.conf

    newinitd "${FILESDIR}/${PN}-initd" ${PN}
    dosed "s:INSPATH:${inspath}:" /etc/init.d/${PN}
}

pkg_postinst() {
    python_version
    python_mod_optimize ${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages/${PN}

    elog "A sample configuration file has been installed in /etc/jabber/${PN}.conf."
    elog "Please edit it and the configuration of your Jabber server to match."
    elog "Don't forget the database connection too. If it's your first install, you"
    elog "need to initialize the Database following this documentation:"
    elog "http://wiki.jrudevels.org/Eng:J2J:AdminGuide#Database_setup"
}

pkg_postrm() {
    python_version
    python_mod_cleanup ${ROOT}usr/$(get_libdir)/python${PYVER}/site-packages/${PN}
}
