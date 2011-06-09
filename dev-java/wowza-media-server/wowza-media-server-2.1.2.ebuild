# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils java-pkg-2

MY_PV_ORIG="${PV/_p*}"
MY_PN="WowzaMediaServer"
MY_PKG="${MY_PN}-${MY_PV_ORIG}.tar.bin"
#MY_PATCH="${MY_PN}${MY_PV_ORIG}${PV/*_p/-patch}"

DESCRIPTION="High-performance, extensible and a fully interactive Flash media server."
SRC_URI="http://www.wowzamedia.com/downloads/WowzaMediaServer-${MY_PV_ORIG//./-}/${MY_PKG}"
#	 http://www.wowzamedia.com/downloads/WowzaMediaServer-${MY_PV_ORIG//./-}/${MY_PATCH}.zip"
HOMEPAGE="http://www.wowzamedia.com"
LICENSE="WowzaMediaServerEULA-2.0"
SLOT="0"
RESTRICT=""
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

DEPEND="app-arch/unzip"
RDEPEND=">=virtual/jre-1.6
	 dev-java/bcprov:0
	 dev-java/commons-lang:2.1
	 dev-java/log4j:0"
#	 >=dev-java/jid3lib-0.5.4 ... some obsolet library

S="${WORKDIR}"

src_unpack() {
	# create and unpack main release
	tail -n +697 ${DISTDIR}/${MY_PKG} > ${T}/${PN}.tar.gz || die 'Can not create tar.gz file!'
	unpack "../temp/${PN}.tar.gz"

	# unpack patch and copy patch files over the standard release
	#unpack ${MY_PATCH}.zip
	#cp -pfr ${MY_PATCH}/* ./ || die 'Can not copy patch files!'

	# change location of the log files
	sed -i "s/\\\${com.wowza.wms.ConfigHome}\\/logs\\/wowzamediaserver/\\/var\\/log\\/${PN}\\/wowzamediaserver/" conf/log4j.properties || die 'Can not sed file!'

	# remove un-needed JAR files
	rm -f lib/{bcprov-ext*,commons-lang*,log4j*}.jar || die 'Can not remove JAR files!'

	# replace the un-needed JARS by system ones
	java-pkg_jar-from bcprov bcprov.jar
	java-pkg_jar-from commons-lang-2.1 commons-lang.jar
	java-pkg_jar-from log4j log4j.jar
}

src_install() {
	dodir /var/log/${PN}
	dodir /etc/${PN}/{applications,content,keys}
	insinto /etc/${PN}/conf
	doins conf/*

	# create empty license key file
	touch ${D}/etc/${PN}/conf/Server.license || die 'Can not create the license file!'

	# install basic documentation
	dodoc NOTICE.txt QUICKSTART.html README.html || die

	# install JAR files
	java-pkg_dojar bin/genkey.jar lib/*.jar

	# install additional documentation
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins -r documentation/*
	fi

	if use examples; then
		# remove all installation scripts
		rm -f examples/installall.sh || die 'Can not delete main install script!'
		rm -f examples/{LiveVideoStreaming,RemoteSharedObjects,SHOUTcast,ServerSideModules,SimpleVideoStreaming,VideoChat,VideoRecording}/{install.bat,install.sh} || die 'Can not delete examples install scripts!'

		# remove uncomplete examples and modules
		rm -fr examples/{BWChecker,LoadBalancer,MediaSecurity,TextChat} || die 'Can not delete example directories!'

		# install examples
		java-pkg_doexamples examples

		# prepare installall.sh script
		INST_ALL="examples/installall.sh"
		echo '#!/bin/sh' > ${INST_ALL} || die

		# create new installation scripts for all examples
		for DIR in LiveVideoStreaming SHOUTcast ServerSideModules VideoChat; do
			INST="examples/${DIR}/install.sh"
			APP_DIR=`ls examples/${DIR}/conf`

			echo '#!/bin/sh' >> ${INST} || die
			echo "echo 'Installing ${DIR}...'" >> ${INST} || die
			echo "cp -rf /usr/share/doc/${PF}/examples/${DIR}/conf/* /etc/${PN}/conf/" >> ${INST} || die
			echo "mkdir /etc/${PN}/applications/${APP_DIR}" >> ${INST} || die

			# install the install.sh script
			exeinto /usr/share/doc/${PF}/examples/${DIR}
			doexe ${INST}

			# note the script into the installall.sh script
			echo "./${DIR}/install.sh" >> ${INST_ALL} || die
		done

		# install the installall.sh script
		exeinto /usr/share/doc/${PF}/examples
		doexe ${INST_ALL}

		# install content examples
		insinto /etc/${PN}/content
		doins content/*
	fi

	# create the genkey wrapper
	java-pkg_dolauncher ${PN}-genkey --main main.Main

	# create the wms wrapper
	# (the JAVA_OPTS and JMXOPTIONS option are passed from the conf.d file)
	WMSAPP_HOME="/usr/share/${PN}"
	WMSCONFIG_HOME="/etc/${PN}"
	WMSCONFIG_URL=""
	###$_EXECJAVA $JAVA_OPTS $JMXOPTIONS -Dcom.wowza.wms.AppHome="$WMSAPP_HOME" -Dcom.wowza.wms.ConfigURL="$WMSCONFIG_URL" -Dcom.wowza.wms.ConfigHome="$WMSCONFIG_HOME" -cp $WMSAPP_HOME/bin/wms-bootstrap.jar  $WMSCOMMAND >/dev/null 2>&1 &
	java-pkg_dolauncher ${PN} --main com.wowza.wms.bootstrap.Bootstrap --into /usr/sbin --java_args "\${JAVA_OPTS} \${JMXOPTIONS} -Dcom.wowza.wms.AppHome=${WMSAPP_HOME} -Dcom.wowza.wms.ConfigURL=${WMSCONFIG_URL} -Dcom.wowza.wms.ConfigHome=${WMSCONFIG_HOME}"

	# both wrappers should be in sbin
	mv ${D}/usr/bin ${D}/usr/sbin || die

	# config script
	newconfd ${FILESDIR}/${P}.conf ${PN}

	# init script
	newinitd ${FILESDIR}/${P}.init ${PN}
}

pkg_postinst() {
	einfo "========================================"
	einfo "Insert your license key into the file /etc/${PN}/conf/Server.license."
	if use examples; then
		einfo ""
		einfo "All examples are installed in the directory /usr/share/doc/${PN}/examples/."
	fi
	einfo "========================================"
}
