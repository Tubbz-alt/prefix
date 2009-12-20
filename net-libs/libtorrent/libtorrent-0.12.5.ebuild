# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libtorrent/libtorrent-0.12.5.ebuild,v 1.4 2009/11/23 21:04:08 maekke Exp $

inherit base eutils toolchain-funcs flag-o-matic libtool

DESCRIPTION="LibTorrent is a BitTorrent library written in C++ for *nix."
HOMEPAGE="http://libtorrent.rakshasa.no/"
SRC_URI="http://libtorrent.rakshasa.no/downloads/${P}.tar.gz"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris"

IUSE="debug ipv6"

RDEPEND=">=dev-libs/libsigc++-2.2.2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-solaris-madvise.patch )

src_unpack() {
	base_src_unpack
	cd "${S}"
	elibtoolize #Don't remove. Needed for *bsd.
}

src_compile() {
	replace-flags -Os -O2

	if [[ $(tc-arch) = "x86" ]]; then
		filter-flags -fomit-frame-pointer -fforce-addr
	fi

	# need this, or configure script bombs out on some null shift, bug #291229
	export CONFIG_SHELL=${BASH}

	econf \
		$(use_enable debug) \
		$(use_enable ipv6) \
		--enable-aligned \
		--enable-static \
		--enable-shared \
		$(use kernel_linux && echo --with-posix-fallocate) \
		--disable-dependency-tracking \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS NEWS README
}
