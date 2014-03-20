EAPI="5"

inherit rpm 

DESCRIPTION="Vagrant is a tool for building complete development environments."
HOMEPAGE="http://www.vagrantup.com"
SRC_URI="
    x86?   ( https://dl.bintray.com/mitchellh/vagrant/vagrant_${PV}_i686.rpm )
    amd64? ( https://dl.bintray.com/mitchellh/vagrant/vagrant_${PV}_x86_64.rpm )
    "

SLOT="0"
KEYWORDS="x86 amd64"

DEPEND="
    sys-libs/zlib
    "
RDEPEND="${DEPEND}"

RESTRICT="mirror"
QA_PRESTRIPPED="/usr/bin/${PN}"

S=${WORKDIR}

src_unpack() {
    rpm_src_unpack "${A}"
    cd "${S}"
}

src_install() {
    exeinto /usr/bin
    doexe usr/bin/${PN} || die
}
