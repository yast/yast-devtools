# $Id$

htmldir = @docdir@/ycpdoc/example
examples = example.ycp example2.ycp mis.ycp modules.ycp \
	 deprecated.ycp struct1.ycp
genfiles = index.html $(wildcard *.html)
html_DATA =	\
		$(examples) \
		$(genfiles)
CLEANFILES = $(genfiles)

index.html: $(examples)
	$(srcdir)/../../src/ycpdoc -d. $^

EXTRA_DIST = $(html_DATA)
