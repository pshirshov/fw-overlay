# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils subversion java-pkg-2 java-ant-2

ESVN_REPO_URI="http://ivyidea.googlecode.com/svn/trunk"
ESVN_PROJECT="ivyidea"

SLOT="0"
RDEPEND=">=virtual/jre-1.4
        >=dev-util/idea-10.5
        >=dev-java/ant-core-1.7.0
        >=app-portage/portage-utils-0.3.1" # fuck!
DEPEND=">=virtual/jdk-1.4
        ${RDEPEND}"

S=${WORKDIR}/${PN}

DESCRIPTION="Intellij IDEA plugin for resolving dependencies using apache ivy and adding them in IntelliJ."
HOMEPAGE="http://code.google.com/p/ivyidea/"


LICENSE="Apache-2.0"
IUSE=""
KEYWORDS="~x86 ~amd64"
S="${WORKDIR}/${PN}"

EANT_BUILD_XML="ivy-idea.xml"
EANT_BUILD_TARGET="bundle-all"

get_idea_dir() {
    # ok... just try to find out idea runtime library
    local idea_files=($(qlist -e dev-util/idea))

    local found_libs=( )
    for i in ${idea_files[@]}; do
       if [[ "${i}" =~ "idea_rt.jar" ]]; then
         found_libs=( ${found_libs[@]-} $(echo "${i}") )
      fi
    done

    [[ "${#found_libs[*]}" -eq "1" ]] || die "Multiply IDEA installations found!"
    echo "$(dirname $(dirname ${found_libs}))"
}

src_compile() {
    # move  build file to spurce dir
    cp -r ${FILESDIR}/ivy-idea.xml ${S}

    EANT_EXTRA_ARGS="-Didea.home=$(get_idea_dir)"
    java-pkg-2_src_compile
}

src_install() {
    local idea_plugins_dir="$(get_idea_dir)/plugins"
    [[ -d "${idea_plugins_dir}" ]] || die "Can't find IDEA plugins directory!"

    unzip "${S}/build/dist/IvyIDEA-*.zip" -d "${S}/build/dist/"
    insinto "${idea_plugins_dir}/IvyIDEA/"
    doins -r build/dist/IvyIDEA/*
}
