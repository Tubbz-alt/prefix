# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gconf/gconf-2.20.1-r1.ebuild,v 1.11 2008/04/20 01:36:03 vapier Exp $

inherit gnome2 autotools

MY_PN=GConf
MY_P=${MY_PN}-${PV}
PVP=(${PV//[-\._]/ })

DESCRIPTION="Gnome Configuration System and Daemon"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="mirror://gnome/sources/${MY_PN}/${PVP[0]}.${PVP[1]}/${MY_P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~x86-interix ~amd64-linux ~x86-linux"
IUSE="debug doc ldap"

RDEPEND=">=dev-libs/glib-2.10
		 >=x11-libs/gtk+-2.8.16
		 >=gnome-base/orbit-2.4
		 >=dev-libs/libxml2-2
		 ldap? ( net-nds/openldap )"
DEPEND="${RDEPEND}
		>=dev-util/intltool-0.35
		>=dev-util/pkgconfig-0.9
		doc? ( >=dev-util/gtk-doc-1 )"

# FIXME : consider merging the tree (?)
DOCS="AUTHORS ChangeLog NEWS README TODO"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	G2CONF="${G2CONF} --enable-gtk $(use_enable debug) $(use_with ldap openldap)"
	kill_gconf
}

src_unpack() {
	gnome2_src_unpack

	# fix bug #193442
	epatch "${FILESDIR}/${P}-automagic-ldap.patch"
	use doc || epatch "${FILESDIR}/${P}-drop-gtk-doc.patch"

	eautoreconf
}

src_install() {
	gnome2_src_install

	# hack hack
	dodir /etc/gconf/gconf.xml.mandatory
	dodir /etc/gconf/gconf.xml.defaults
	touch "${ED}"/etc/gconf/gconf.xml.mandatory/.keep${SLOT}
	touch "${ED}"/etc/gconf/gconf.xml.defaults/.keep${SLOT}

	echo 'CONFIG_PROTECT_MASK="/etc/gconf"' > 50gconf
	doenvd 50gconf || die
	dodir /root/.gconfd
}

pkg_preinst() {
	kill_gconf
}

pkg_postinst() {
	kill_gconf

	#change the permissions to avoid some gconf bugs
	einfo "changing permissions for gconf dirs"
	find  /etc/gconf/ -type d -exec chmod ugo+rx "{}" \;

	einfo "changing permissions for gconf files"
	find  /etc/gconf/ -type f -exec chmod ugo+r "{}" \;
}

kill_gconf() {
	# this function will kill all running gconfd that could be causing troubles
	if [ -x "${EPREFIX}"/usr/bin/gconftool ]
	then
		"${EPREFIX}"/usr/bin/gconftool --shutdown
	fi
	if [ -x "${EPREFIX}"/usr/bin/gconftool-1 ]
	then
		"${EPREFIX}"/usr/bin/gconftool-1 --shutdown
	fi

	# and for gconf 2
	if [ -x "${EPREFIX}"/usr/bin/gconftool-2 ]
	then
		"${EPREFIX}"/usr/bin/gconftool-2 --shutdown
	fi
	return 0
}
