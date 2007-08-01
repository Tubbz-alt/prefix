# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/opencdk/opencdk-0.5.7.ebuild,v 1.16 2007/07/12 10:12:49 uberlord Exp $

EAPI="prefix"

inherit libtool

DESCRIPTION="Open Crypto Development Kit for basic OpenPGP message manipulation"
HOMEPAGE="http://www.gnutls.org/"
SRC_URI="ftp://ftp.gnutls.org/pub/gnutls/opencdk/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~mips ~ppc-macos ~x86 ~x86-macos"
IUSE="doc"

RDEPEND=">=dev-libs/libgcrypt-1.1.94"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5.6"

src_unpack() {
	unpack ${A}
	cd "${S}"
	elibtoolize
}

src_install() {
	make DESTDIR="${D}" install || die "installed failed"
	dodoc AUTHORS ChangeLog NEWS README README-alpha THANKS TODO
	use doc && dohtml doc/opencdk-api.html
}
