# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/zsh/zsh-4.3.4-r1.ebuild,v 1.9 2008/01/10 09:26:36 vapier Exp $

EAPI="prefix"

inherit eutils multilib autotools

LOVERS_PV=0.5
LOVERS_P=zsh-lovers-${LOVERS_PV}

DESCRIPTION="UNIX Shell similar to the Korn shell"
HOMEPAGE="http://www.zsh.org/"
SRC_URI="ftp://ftp.zsh.org/pub/${P}.tar.bz2
	mirror://gentoo/${P}-zshcalsys.tar.bz2
	examples? (
	http://www.grml.org/repos/zsh-lovers_${LOVERS_PV}.orig.tar.gz )
	doc? ( ftp://ftp.zsh.org/pub/${P}-doc.tar.bz2 )"

LICENSE="ZSH"
SLOT="0"
KEYWORDS="~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="maildir static doc examples pcre caps unicode"

RDEPEND=">=sys-libs/ncurses-5.1
	caps? ( sys-libs/libcap )
	pcre? ( >=dev-libs/libpcre-3.9 )"
DEPEND="sys-apps/groff
	${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# fix zshall problem with soelim
	ln -s Doc man1
	mv Doc/zshall.1 Doc/zshall.1.soelim
	soelim Doc/zshall.1.soelim > Doc/zshall.1

	# fixes #201022 and
	# http://www.zsh.org/mla/workers/2007/msg01065.html
	rm Util/difflog.pl

	epatch "${FILESDIR}/${PN}"-init.d-gentoo.diff
	epatch "${FILESDIR}/${P}"-configure-changequote.patch
	eautoreconf

	cp "${FILESDIR}"/zprofile "${T}"/zprofile
	eprefixify "${T}"/zprofile
}

src_compile() {
	local myconf=

	if use static ; then
		myconf="${myconf} --disable-dynamic"
		LDFLAGS="${LDFLAGS} -static"
	fi

	if [[ ${CHOST} == *-darwin* ]]; then
		LDFLAGS="${LDFLAGS} -Wl,-x"
		myconf="${myconf} --enable-libs=-liconv"
	fi

	econf \
		--bindir="${EPREFIX}"/bin \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--enable-etcdir="${EPREFIX}"/etc/zsh \
		--enable-zshenv="${EPREFIX}"/etc/zsh/zshenv \
		--enable-zlogin="${EPREFIX}"/etc/zsh/zlogin \
		--enable-zlogout="${EPREFIX}"/etc/zsh/zlogout \
		--enable-zprofile="${EPREFIX}"/etc/zsh/zprofile \
		--enable-zshrc="${EPREFIX}"/etc/zsh/zshrc \
		--enable-fndir="${EPREFIX}"/usr/share/zsh/${PV%_*}/functions \
		--enable-site-fndir="${EPREFIX}"/usr/share/zsh/site-functions \
		--enable-function-subdirs \
		--enable-ldflags="${LDFLAGS}" \
		--with-curses-terminfo \
		--with-tcsetpgrp \
		$(use_enable maildir maildir-support) \
		$(use_enable pcre) \
		$(use_enable caps) \
		$(use_enable unicode multibyte) \
		${myconf} || die "configure failed"

	if use static ; then
		# compile all modules statically, see Bug #27392
		sed -i -e "s/link=no/link=static/g" \
			-e "s/load=no/load=yes/g" \
			config.modules || die
#	else
#		sed -i -e "/LIBS/s%-lpcre%${EPREFIX}/usr/$(get_libdir)/libpcre.a%" Makefile
	fi

	emake || die "make failed"
}

src_test() {
	local f=
	for f in /dev/pt* ; do
		addpredict "$f"
	done
	make check || die "make check failed"
}

src_install() {
	einstall \
		bindir="${ED}"/bin \
		libdir="${ED}"/usr/$(get_libdir) \
		fndir="${ED}"/usr/share/zsh/${PV%_*}/functions \
		sitefndir="${ED}"/usr/share/zsh/site-functions \
		scriptdir="${ED}"/usr/share/zsh/${PV%_*}/scripts \
		install.bin install.man install.modules \
		install.info install.fns || die "make install failed"

	insinto /etc/zsh
	doins "${T}"/zprofile

	keepdir /usr/share/zsh/site-functions
	insinto /usr/share/zsh/${PV%_*}/functions/Prompts
	doins "${FILESDIR}"/prompt_gentoo_setup || die

	# install miscellaneous scripts; bug #54520
	sed -i -e "s:/usr/local:${EPREFIX}/usr:g" {Util,Misc}/* || "sed failed"
	insinto /usr/share/zsh/${PV%_*}/Util
	doins Util/* || die "doins Util scripts failed"
	insinto /usr/share/zsh/${PV%_*}/Misc
	doins Misc/* || die "doins Misc scripts failed"

	dodoc ChangeLog* META-FAQ README config.modules

	if use doc ; then
		dohtml Doc/*
		insinto /usr/share/doc/${PF}
		doins Doc/zsh.{dvi,pdf}
	fi

	if use examples; then
		cd "${WORKDIR}/${LOVERS_P}"
		doman  zsh-lovers.1    || die "doman zsh-lovers failed"
		dohtml zsh-lovers.html || die "dohtml zsh-lovers failed"
		docinto zsh-lovers
		dodoc zsh.vim README
		insinto /usr/share/doc/"${PF}"/zsh-lovers
		doins zsh-lovers.{ps,pdf} refcard.{dvi,ps,pdf}
		doins -r zsh_people || die "doins zsh_people failed"
		cd -
	fi

	docinto StartupFiles
	dodoc StartupFiles/z*
}

pkg_preinst() {
	# Our zprofile file does the job of the old zshenv file
	# Move the old version into a zprofile script so the normal
	# etc-update process will handle any changes.
	if [ -f "${EROOT}/etc/zsh/zshenv" -a ! -f "${EROOT}/etc/zsh/zprofile" ]; then
		ewarn "Renaming ${EPREFIX}/etc/zsh/zshenv to ${EPREFIX}/etc/zsh/zprofile."
		ewarn "The zprofile file does the job of the old zshenv file."
		mv "${EROOT}"/etc/zsh/{zshenv,zprofile}
	fi
}

pkg_postinst() {
	elog
	elog "If you want to enable Portage completions and Gentoo prompt,"
	elog "emerge app-shells/zsh-completion and add"
	elog "	autoload -U compinit promptinit"
	elog "	compinit"
	elog "	promptinit; prompt gentoo"
	elog "to your ~/.zshrc"
	elog
	elog "Also, if you want to enable cache for the completions, add"
	elog "	zstyle ':completion::complete:*' use-cache 1"
	elog "to your ~/.zshrc"
	elog
	# see Bug 26776
	ewarn
	ewarn "If you are upgrading from zsh-4.0.x you may need to"
	ewarn "remove all your old ~/.zcompdump files in order to use"
	ewarn "completion.  For more info see zcompsys manpage."
	ewarn
}
