#
# Makefile.am for devtools/devtools/doc
#

SUBDIRS = skeletons

htmldir = $(docdir)/devtools

STYLESHEET_HTML=../../docbook/stylesheets/customize-html.xsl

XSLTPROC=@XSLTPROC@
XSLTPROC_FLAGS=@XSLTPROC_FLAGS@
DOCBOOK_ROOT=@DOCBOOK_ROOT@
XML_CATALOG=@XML_CATALOG@
xml_files =  $(wildcard *.xml) 

html_DATA = $(wildcard html/*.html) \
	    rny2rnc.html \
	    html/index.html \
	    html/susebooks.css


html/index.html: yast2-devtools.xml
	XML_CATALOG_FILES=$(XML_CATALOG)\
	$(XSLTPROC) $(XSLTPROC_FLAGS) --xinclude \
	$(STYLESHEET_HTML) $<



html/susebooks.css: 
	cp ../../docbook/css/susebooks.css html
	cp -a ../../docbook/images html
	find html -name "Makefile*"  | xargs rm

clean-local:
	rm -rf html

install-data-local:
	mkdir -p $(DESTDIR)$(htmldir)
	cp -a $(srcdir)/html/images $(DESTDIR)$(htmldir)

EXTRA_DIST =  $(xml_files) rny2rnc.html

