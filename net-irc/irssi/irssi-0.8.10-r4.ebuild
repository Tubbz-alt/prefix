# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/irssi/irssi-0.8.10-r4.ebuild,v 1.15 2007/09/22 19:13:41 swegener Exp $

EAPI="prefix"

inherit perl-module eutils

DESCRIPTION="A modular textUI IRC client with IPv6 support"
HOMEPAGE="http://irssi.org/"
SRC_URI="http://irssi.org/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc-macos ~x86 ~x86-macos"
IUSE="ipv6 perl ssl socks5"

RDEPEND="sys-libs/ncurses
	>=dev-libs/glib-2.2.1
	ssl? ( dev-libs/openssl )
	perl? ( dev-lang/perl )
	socks5? ( >=net-proxy/dante-1.1.18 )"
DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9.0"
RDEPEND="${RDEPEND}
	perl? ( !net-im/silc-client )
	!net-irc/irssi-svn"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-dcc-segv.patch
	epatch "${FILESDIR}"/${P}-line-split.patch

	epunt_cxx
}

src_compile() {
	econf \
		--with-proxy \
		--with-ncurses \
		--with-perl-lib=vendor \
		$(use_with perl) \
		$(use_with socks5 socks) \
		$(use_enable ssl) \
		$(use_enable ipv6) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make \
		DESTDIR="${D}" \
		docdir="${EPREFIX}"/usr/share/doc/${PF} \
		install || die "make install failed"

	use perl && fixlocalpod

	dodoc AUTHORS ChangeLog README TODO NEWS || die "dodoc failed"
}
