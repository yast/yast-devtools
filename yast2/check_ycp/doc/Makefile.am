#
# Makefile.am for devtools/yast2/check_ycp/doc
#
#
htmldir = $(docdir)/check_ycp

STYLESHEET_HTML=$(srcdir)/../../../docbook/stylesheets/customize-html.xsl

XSLTPROC=@XSLTPROC@
XSLTPROC_FLAGS=@XSLTPROC_FLAGS@
DOCBOOK_ROOT=@DOCBOOK_ROOT@
XML_CATALOG=@XML_CATALOG@
xml_files =  $(wildcard *.xml) 

html_DATA = $(wildcard html/*.html) \
	    html/index.html \
	    html/yast2docs.css


html/index.html: check_ycp.xml
	XML_CATALOG_FILES=$(XML_CATALOG)\
	$(XSLTPROC) $(XSLTPROC_FLAGS) --xinclude \
	$(STYLESHEET_HTML) $<


html/yast2docs.css: html/index.html
	cp $(srcdir)/../../../docbook/css/yast2docs.css $@
	cp -a $(srcdir)/../../../docbook/images html
	find html -name "Makefile*"  | xargs rm

clean-local:
	rm -rf html

install-data-local:
	mkdir -p $(DESTDIR)$(htmldir)
	cp -a $(srcdir)/html/images $(DESTDIR)$(htmldir)

EXTRA_DIST =  $(xml_files)

