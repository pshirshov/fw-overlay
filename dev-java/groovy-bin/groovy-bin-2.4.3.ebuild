EAPI=5
inherit eutils user java-pkg-2

DESCRIPTION="Groovy is a high-level dynamic language for the JVM"
HOMEPAGE="http://groovy-lang.org/"
SRC_URI="http://dl.bintray.com/groovy/maven/groovy-binary-${PV}.zip"

LICENSE="codehaus-groovy"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="
    >=virtual/jdk-1.6
    "
RDEPEND="${DEPEND}"

S="${WORKDIR}/groovy-${PV}"
INSTALL_DIR="/opt/groovy"

src_prepare() {
    cd "${S}"
}

src_install() {
    insinto ${INSTALL_DIR}

    doins -r *

    for i in bin/* ; do
        if [[ $i == *.bat ]]; then
            continue
        fi
        fperms 755 ${INSTALL_DIR}/${i}
        make_wrapper "$(basename ${i})" "${INSTALL_DIR}/${i}"
    done
}
