#
# Makefile.am for y2c_XXpkgXX/testsuite
#
# $Id$
#

AUTOMAKE_OPTIONS = dejagnu

# *.yh: the YCP files which should not be run using runtest
#       (e.g. common includes)
EXTRA_DIST =	$(wildcard tests/*.out)	\
		$(wildcard tests/*.err) \
		$(wildcard tests/*.ycp) \
		$(wildcard tests/*.yh)

testsuite_prepare=/usr/lib/YaST2/testsuite/Makefile.testsuite
testsuite_make = \
	target=`echo $@ | sed 's/-local//'` ; \
	echo "Making '$$target' using make -f $(testsuite_prepare)..." ; \
	make -f $(testsuite_prepare) RPMNAME=$(RPMNAME) srcdir=$(srcdir) $$target

all-local: $(testsuite_prepare)
	$(testsuite_make)

clean-local: $(testsuite_prepare)
	$(testsuite_make)

check-local: $(testsuite_prepare)
	$(testsuite_make)

