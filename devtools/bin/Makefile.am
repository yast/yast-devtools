#
# Makefile.am for devtools/devtools/bin
#

pkgdatadir = @YAST2DEVTOOLS@/bin

bin_SCRIPTS = y2tool
ybin_SCRIPTS = makedep.sh

pkgdata_SCRIPTS = 				\
	y2autoconf 				\
	y2automake 				\
	tagversion 				\
	checkin-stable				\
	devtools-migration			\
	create-new-package			\
	create-spec				\
	for-proofread				\
	kill-leftover-stuff			\
	get-lib					\
	version

EXTRA_DIST = $(bin_SCRIPTS) $(ybin_SCRIPTS) $(pkgdata_SCRIPTS) version.in

