#
# Makefile.am for devtools/yast2/check_ycp/doc
#

docdir	= 	@YAST2DOC@
sgmldir	=	$(docdir)
htmldir	=	$(docdir)/html

sgml_DATA =	\
	check_ycp.sgml


html_DATA =	\
	index.html		\
	check_ycp.html		\
	check_ycp-1.html	\
	check_ycp-2.html	\
	check_ycp-3.html	\
	check_ycp-4.html	\
	check_ycp-5.html	\
	check_ycp-6.html	\
	check_ycp-7.html	\
	check_ycp-8.html	\
	check_ycp-9.html	\
	check_ycp-10.html	\
	check_ycp-11.html

$(html_DATA): $(sgml_DATA)
	$(SGML2HTML) $(sgml_DATA)
	ln -sf check_ycp.html index.html

html: $(html_DATA)


text:
	$(SGML2TXT) $(sgml_DATA)

info:
	$(SGML2INFO) $(sgml_DATA)

latex:
	$(SGML2LATEX) $(sgml_DATA)


EXTRA_DIST = $(html_DATA) $(sgml_DATA)


CLEANFILES = $(html_DATA)

