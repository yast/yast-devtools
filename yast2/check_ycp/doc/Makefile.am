#
# Makefile.am for devtools/yast2/check_ycp/doc
#
#
htmldir = $(docdir)/check_ycp

XSLTPROC="/usr/bin/xsltproc"
BUILD=html
STYLESHEET_HTML=../../../docbook/stylesheets/customize-html.xsl
IMAGES=$(wildcard $(BUILD)/images/* $(BUILD)/images/navig/* $(BUILD)/images/admon/*)

xml_files =  $(wildcard *.xml) 

html_DATA = $(wildcard html/*.html)  \
	    html/index.html  \
	    html/susebooks.css

html/index.html: check_ycp-section.xml check_ycp.xml  
	xsltproc \
	-stringparam base.dir "$(BUILD)/" \
	--xinclude \
	$(STYLESHEET_HTML)  check_ycp.xml
	cp ../../../docbook/css/susebooks.css $(BUILD)
	cp -a ../../../docbook/images $(BUILD)
	find $(BUILD) -name "Makefile*"  | xargs rm

validate:
	xmllint --dropdtd --loaddtd check_ycp-section.xml
clean-local:
	rm -rf $(BUILD)/*.html
	rm -rf $(BUILD)/images
	rm -rf $(BUILD)/susebooks.css

install-data-local:
	mkdir -p $(DESTDIR)$(htmldir)
	cp -a $(srcdir)/$(BUILD)/images $(DESTDIR)$(htmldir)

	
EXTRA_DIST =  $(xml_files)
