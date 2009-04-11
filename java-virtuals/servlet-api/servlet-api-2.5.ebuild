# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/java-virtuals/servlet-api/servlet-api-2.5.ebuild,v 1.8 2008/05/12 15:19:02 corsair Exp $

EAPI=1

inherit java-virtuals-2

DESCRIPTION="Virtual for servlet api"
HOMEPAGE="http://java.sun.com/products/servlet/"
SRC_URI=""

LICENSE="as-is"
SLOT="${PV}"
KEYWORDS="~x86-freebsd ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="|| (
		dev-java/tomcat-servlet-api:${SLOT}
		dev-java/resin-servlet-api:${SLOT}
	)"
DEPEND=""

JAVA_VIRTUAL_PROVIDES="tomcat-servlet-api-${SLOT} resin-servlet-api-${SLOT}"
