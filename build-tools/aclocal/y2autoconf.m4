dnl Macros that should obsolete those processed by "y2tool y2autoconf"

AC_DEFUN([YAST2_INIT_COMMON],
[
dnl Check for presence of file 'RPMNAME'
AC_CONFIG_SRCDIR([RPMNAME])

RPMNAME=`cat RPMNAME`
VERSION=`cat VERSION`
MAINTAINER=`cat MAINTAINER`

AC_INIT($RPMNAME, $VERSION, http://bugs.opensuse.org/, $RPMNAME)

dnl Checking host/target/build systems, for make, install etc.
AC_CANONICAL_TARGET
dnl Perform program name transformation
AC_ARG_PROGRAM

AC_PREFIX_DEFAULT(/usr)

AM_INIT_AUTOMAKE(tar-ustar) dnl searches for some needed programs

dnl Important YaST2 variables
AC_SUBST(VERSION)
AC_SUBST(RPMNAME)
AC_SUBST(MAINTAINER)

dnl pkgconfig honors lib64
pkgconfigdir=\${libdir}/pkgconfig
pkgconfigdatadir=\${datadir}/pkgconfig
yast2dir=\${prefix}/share/YaST2

ybindir=\${prefix}/lib/YaST2/bin
# FIXME duplicates execcompdir
ystartupdir=\${prefix}/lib/YaST2
plugindir=\${libdir}/YaST2/plugin
includedir=\${prefix}/include/YaST2
potdir=\${docdir}/pot

docdir=\${prefix}/share/doc/packages/$RPMNAME
mandir=\${prefix}/share/man

execcompdir=\${prefix}/lib/YaST2
agentdir=${execcompdir}/servers_non_y2

ydatadir=${yast2dir}/data
imagedir=${yast2dir}/images
themedir=${yast2dir}/theme
localedir=${yast2dir}/locale
clientdir=${yast2dir}/clients
moduledir=${yast2dir}/modules
yncludedir=${yast2dir}/include
schemadir=${yast2dir}/schema
scrconfdir=${yast2dir}/scrconf
desktopdir=\${prefix}/share/applications/YaST2


AC_SUBST(pkgconfigdir)
AC_SUBST(pkgconfigdatadir)

AC_SUBST(yast2dir)

AC_SUBST(ybindir)
AC_SUBST(ystartupdir)
AC_SUBST(plugindir)
AC_SUBST(includedir)
AC_SUBST(potdir)
AC_SUBST(execcompdir)

AC_SUBST(docdir)
AC_SUBST(mandir)

AC_SUBST(ydatadir)
AC_SUBST(imagedir)
AC_SUBST(themedir)
AC_SUBST(localedir)
AC_SUBST(clientdir)
AC_SUBST(moduledir)
AC_SUBST(yncludedir)
AC_SUBST(schemadir)
AC_SUBST(scrconfdir)
AC_SUBST(agentdir)
AC_SUBST(desktopdir)

fillupdir_d="/var/adm/fillup-templates"
AC_ARG_WITH(fillupdir,
    AS_HELP_STRING([--with-fillupdir=DIR],
		   [where to place fillup templates (default $fillupdir_d.]),
    [ fillupdir="$withval" ],
    [ fillupdir="$fillupdir_d" ])
AC_SUBST(fillupdir)
])
