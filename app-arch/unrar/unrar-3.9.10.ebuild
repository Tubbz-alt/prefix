# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/unrar/unrar-3.9.10.ebuild,v 1.1 2010/03/19 02:27:22 vapier Exp $

inherit toolchain-funcs eutils

MY_PN=${PN}src
DESCRIPTION="Uncompress rar files"
HOMEPAGE="http://www.rarlab.com/rar_add.htm"
SRC_URI="http://www.rarlab.com/rar/${MY_PN}-${PV}.tar.gz"

LICENSE="unRAR"
SLOT="0"
KEYWORDS="~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

DEPEND="!app-arch/unrar-gpl"

S=${WORKDIR}/unrar

src_unpack() {
	unpack ${A}
	cd "${S}"

	[[ ${CHOST} == *-interix* ]] && epatch "${FILESDIR}"/${PN}-3.8.5-interix.patch
}

src_compile() {
	emake \
		-f makefile.unix \
		CXXFLAGS="${CXXFLAGS}" \
		CXX="$(tc-getCXX)" \
		STRIP="true" || die "emake failed"
}

src_install() {
	dobin unrar || die
	dodoc readme.txt
}
