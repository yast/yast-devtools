#
# Makefile.am for devtools/devtools/doc
#

SUBDIRS = skeletons

sgmldir	= $(docdir)
htmldir	= $(docdir)/html

sgml_DATA =	\
	yast2-devtools.sgml

html_DATA =					\
	index.html				\
	yast2-devtools.html			\
	yast2-devtools-1.html			\
	yast2-devtools-2.html			\
	yast2-devtools-3.html			\
	yast2-devtools-4.html			\
	yast2-devtools-5.html			\
	yast2-devtools-6.html			\
	yast2-devtools-7.html			\
	yast2-devtools-8.html			\
	yast2-devtools-9.html


$(html_DATA): $(sgml_DATA)
	$(SGML2HTML) $^
	ln -sf yast2-devtools.html index.html


html: $(html_DATA)


text:
	$(SGML2TXT) $(sgml_DATA)

info:
	$(SGML2INFO) $(sgml_DATA)

latex:
	$(SGML2LATEX) $(sgml_DATA)

ps: latex
	dvips yast2-devtools.dvi


EXTRA_DIST = $(html_DATA) $(sgml_DATA)


CLEANFILES = $(html_DATA) 			\
	yast2-devtools.dvi			\
	yast2-devtools.ps			\
	yast2-devtools.txt			\
	yast2-devtools.info

