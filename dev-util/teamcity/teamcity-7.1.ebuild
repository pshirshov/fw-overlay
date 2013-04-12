EAPI="3"

inherit eutils

DESCRIPTION="Extensible continuous integration server"
HOMEPAGE="http://www.jetbrains.com/teamcity/"
LICENSE="MIT"
SRC_URI="http://download.jetbrains.com/teamcity/TeamCity-${PV}.tar.gz"
RESTRICT="mirror"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

RDEPEND=">=virtual/jdk-1.6"

S="${WORKDIR}/TeamCity"
INSTALL_DIR="/opt/teamcity"

QA_PRESTRIPPED="${INSTALL_DIR}/webapps/ROOT/WEB-INF/lib/libnet_sf_colorer.so"
QA_TEXTRELS="*"

pkg_setup() {
    enewgroup teamcity
    enewuser teamcity -1 /bin/bash /opt/teamcity teamcity
}

src_prepare() {
    cd "${S}"
    find bin/ \( -name \*.exe -or -name \*.bat -or -name \*.cmd \) -delete
}

src_install() {
    insinto ${INSTALL_DIR}

    doins -r TeamCity-readme.txt Tomcat-running.txt bin buildAgent conf devPackage lib licenses temp webapps

    newinitd "${FILESDIR}/init.sh" teamcity
    newconfd "${FILESDIR}/conf" teamcity

    fowners -R teamcity:teamcity ${INSTALL_DIR}

    for i in bin/*.sh ; do
        fperms 755 ${INSTALL_DIR}/${i}
    done

    for i in buildAgent/bin/*.sh ; do
        fperms 755 ${INSTALL_DIR}/${i}
    done

    # Protect teamcity conf on upgrade
    echo "CONFIG_PROTECT=\"${INSTALL_DIR}/conf ${INSTALL_DIR}/buildAgent/conf\"" > "${T}/25teamcity" || die
    doenvd "${T}/25teamcity"
}
