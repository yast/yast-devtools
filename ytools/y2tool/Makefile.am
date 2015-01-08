#
# Makefile.am for devtools/devtools/bin
#

pkgdatadir = @YAST2DEVTOOLS@/bin

pkgdata_SCRIPTS = 				\
	check_icons				\
	check-textdomain			\
	find-unused-published			\
	get-lib					\
	pot-spellcheck				\
	rny2rnc					\
	showy2log				\
	tagversion

confdatadir = @YAST2DEVTOOLS@/data
confdata_DATA = \
	rubocop_yast_style.yml

EXTRA_DIST = $(pkgdata_SCRIPTS) $(confdata_DATA)
