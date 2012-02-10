# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/liblockfile/liblockfile-1.09.ebuild,v 1.1 2011/12/18 14:35:28 eras Exp $

EAPI=4

inherit eutils multilib autotools

DESCRIPTION="Implements functions designed to lock the standard mailboxes"
HOMEPAGE="http://www.debian.org/"
SRC_URI="mirror://debian/pool/main/libl/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

pkg_setup() {
	enewgroup mail 12
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.06-respectflags.patch
	epatch "${FILESDIR}"/${PN}-orphan-file.patch

	# I didn't feel like making the Makefile portable
	[[ ${CHOST} == *-darwin* ]] \
		&& cp ${FILESDIR}/Makefile.Darwin.in Makefile.in
	
	eautoreconf
}

src_configure() {
	# we never want to use LDCONFIG
	export LDCONFIG=${EPREFIX}/bin/true
	local grp=mail
	# in privileged installs this is "mail"
	use prefix && grp=$(id -gn)
	econf --with-mailgroup=${grp} --enable-shared
}

src_install() {
	dodir /usr/{bin,include,$(get_libdir)} /usr/share/man/{man1,man3}
	emake ROOT="${ED}" install
	dodoc README Changelog
}
