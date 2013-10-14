dnl check for docbook					-*- autoconf -*-


AC_DEFUN([AX_CHECK_DOCBOOK], [
AC_MSG_CHECKING([for docbook stylesheets])
# It's just rude to go over the net to build
XSLTPROC_FLAGS=--nonet
DOCBOOK_ROOT=
if test -f /etc/xml/catalog; then
        XML_CATALOG=/etc/xml/catalog
        CAT_ENTRY_START='<!--'
        CAT_ENTRY_END='-->'
fi
for i in /usr/share/sgml/docbook/stylesheet/xsl/nwalsh /usr/share/sgml/docbook/xsl-stylesheets /usr/share/xml/docbook/stylesheet/nwalsh/current; do
        if test -d "$i"; then
                DOCBOOK_ROOT=$i
        fi
done
if test -z "$DOCBOOK_ROOT"; then
	AC_MSG_ERROR([not found, install docbook-xsl-stylesheets.rpm])
fi
AC_MSG_RESULT($DOCBOOK_ROOT)

AC_PATH_PROG(XSLTPROC,xsltproc)
XSLTPROC_WORKS=no
if test -n "$XSLTPROC"; then
        AC_MSG_CHECKING([whether xsltproc works])

        if test -n "$XML_CATALOG"; then
                DB_FILE="http://docbook.sourceforge.net/release/xsl/current/xhtml/docbook.xsl"
        else
                DB_FILE="$DOCBOOK_ROOT/xhtml/docbook.xsl"
        fi

        $XSLTPROC $XSLTPROC_FLAGS $DB_FILE >/dev/null 2>>config.log << END
<?xml version="1.0" encoding='ISO-8859-1'?>
<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.1.2//EN" "http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd">
<book id="test">
</book>
END
        if test "$?" = 0; then
                XSLTPROC_WORKS=yes
        fi
        AC_MSG_RESULT($XSLTPROC_WORKS)
else
    AC_MSG_ERROR([xsltproc required but not found])
fi
AM_CONDITIONAL(have_xsltproc, test "$XSLTPROC_WORKS" = "yes")

AC_SUBST(XML_CATALOG)
AC_SUBST(XSLTPROC_FLAGS)
AC_SUBST(DOCBOOK_ROOT)
AC_SUBST(CAT_ENTRY_START)
AC_SUBST(CAT_ENTRY_END)

])
