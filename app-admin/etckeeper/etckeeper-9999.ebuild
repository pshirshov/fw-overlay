# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils git

DESCRIPTION="Etckeeper is a collection of tools to let /etc be stored in a git, mercurial, or bzr repository."
HOMEPAGE="http://kitenet.net/~joey/code/etckeeper/"

EGIT_REPO_URI="git://git.kitenet.net/etckeeper"
EGIT_TREE="0.41"

LICENSE="GPL-2"
IUSE="mercurial git bzr mercurial bash-completion auto-commit"
KEYWORDS="~x86 ~amd64 ~hppa ~ppc ~sparc"
SLOT="0"

DEPEND=">=app-portage/gentoolkit-0.2.3-r1
	metastore? ( sys-apps/metastore )
	git? ( dev-vcs/git )
	mercurial? ( dev-util/mercurial )
	bzr? ( dev-util/bzr )
	bash-completion? ( app-shells/bash-completion ) "

src_unpack() {
	git_src_unpack
	cd "${S}"
	epatch "${FILESDIR}"/etckeeper-gentoo-0.41.patch
}

src_compile() {
	if use bzr; then
		emake || die "make failed : problem in support python for bzr" 
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	if use bash-completion; then
		install -m 0644 -D bash_completion "${D}/etc/bash_completion.d/etckeeper"
	fi

	if use bzr; then
		./etckeeper-bzr/__init__.py install --root="${D}" || die "Error: bzr support installation"
	fi

	mkdir -p "${D}/etc/portage/"
	cp "${FILESDIR}/autocommit" "${D}/etc/portage/etckeeper" || die "Could not copy autocommit script"
	chmod 755 "${D}/etc/portage/etckeeper"

	if use auto-commit; then
		if [ -d ${ROOT}/etc/portage ] ; then
			echo "source ${ROOT}etc/portage/etckeeper" >> ${ROOT}/etc/portage/bashrc
		fi
	fi
}

pkg_postinst() {
	if use auto-commit; then
		elog "Autocommiting enabeled"
		elog "If you wnat to disable this behaviour then remove this package"
		elog "emerge -C app-admin/etckeeper"
		elog "Then turn off auto-commit use flag and re-emerge this package"
	else
		elog "If you want etckeeper to automatically commit"
		elog "Add this to your ${ROOT}etc/portage/bashrc"
		elog "source ${ROOT}etc/portage/etckeeper"
	fi
}

pkg_postrm() {
	if use auto-commit; then
		if [ -e ${ROOT}/etc/portage/etckeeper ] ; then
			rm -rf ${ROOT}/etc/portage/etckeeper
			sed  -i '/etckeeper/d' ${ROOT}/etc/portage/bashrc
		fi
	fi
}
