#
# Makefile.am for devtools/ycpdoc/doc
#

SUBDIRS = example
htmldir = @docdir@/ycpdoc

html_DATA =	README

README: $(srcdir)/../src/ycpdoc
	pod2text $< >$@

EXTRA_DIST = $(html_DATA)
