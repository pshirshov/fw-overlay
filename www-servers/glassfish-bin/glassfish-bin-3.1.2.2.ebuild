EAPI="5"

inherit eutils

DESCRIPTION="GlassFish is an open-source application server project for the Java EE platform"
HOMEPAGE="http://glassfish.java.net/"
LICENSE="GPL"
SRC_URI="http://download.java.net/glassfish/${PV}/release/glassfish-${PV}.zip"
RESTRICT="mirror"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

RDEPEND=">=virtual/jdk-1.6"

S="${WORKDIR}/glassfish3"
MY_PN="glassfish"
INSTALL_DIR="/opt/${MY_PN}"

pkg_setup() {
    enewgroup glassfish
    enewuser glassfish -1 /bin/bash ${INSTALL_DIR}/home glassfish
}

src_prepare() {
    cd "${S}"
    find . \( -name \*.bat -or -name \*.exe \) -delete
}

src_install() {
    insinto ${INSTALL_DIR}

    doins -r glassfish javadb mq pkg bin
    keepdir ${INSTALL_DIR}/home
    fowners -R glassfish:glassfish ${INSTALL_DIR}
    for i in bin/* ; do
        fperms 755 ${INSTALL_DIR}/${i}
        make_wrapper "$(basename ${i})" "${INSTALL_DIR}/${i}"
    done

    for i in glassfish/bin/* ; do
        fperms 755 ${INSTALL_DIR}/${i}
    done

    fperms 775 ${INSTALL_DIR}/domains

    newinitd "${FILESDIR}/${MY_PN}-init" glassfish

    echo "CONFIG_PROTECT=\"${INSTALL_DIR}/glassfish/config\"" > "${T}/25glassfish" || die
    doenvd "${T}/25glassfish"

    elog "You must be in the glassfish group to use GlassFish without root rights."
}
