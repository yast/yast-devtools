#
# Makefile.am for devtools/devtools/doc
#

SUBDIRS = skeletons

htmldir = $(docdir)/devtools

XSLTPROC="/usr/bin/xsltproc"
BUILD=html
STYLESHEET_HTML=../../docbook/stylesheets/customize-html.xsl

xml_files =  $(wildcard *.xml) 

html_DATA = $(wildcard html/*.html) \
	    rny2rnc.html \
	    $(BUILD)/index.html \
	    $(BUILD)/susebooks.css

$(html_DATA): $(xml_files) 
	xsltproc \
	-stringparam base.dir "$(BUILD)/" \
	--xinclude \
	$(STYLESHEET_HTML) \
	yast2-devtools.xml


$(BUILD)/susebooks.css:
	cp ../../docbook/css/susebooks.css $(BUILD)
	cp -a ../../docbook/images $(BUILD)
	find $(BUILD) -name "Makefile*"  | xargs rm

clean-local:
	rm -rf $(BUILD)/*.html
	rm -rf $(BUILD)/images
	rm -rf $(BUILD)/susebooks.css

#install-data-local:
#	mkdir -p $(htmldir)
#	cp -a $(BUILD)/images $(htmldir)

EXTRA_DIST =  $(xml_files) rny2rnc.html

