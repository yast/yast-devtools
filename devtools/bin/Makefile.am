#
# Makefile.am for devtools/devtools/bin
#

pkgdatadir = @YAST2DEVTOOLS@/bin

bin_SCRIPTS = y2tool
ybin_SCRIPTS = makedep.sh

pkgdata_SCRIPTS = 				\
	checkin-stable				\
	create-new-package			\
	create-spec				\
	devtools-migration			\
	for-proofread				\
	get-lib					\
	kill-leftover-stuff			\
	tagversion 				\
	version					\
	y2autoconf 				\
	y2automake 				\
	y2compile				\
	y2makeall

EXTRA_DIST = $(bin_SCRIPTS) $(ybin_SCRIPTS) $(pkgdata_SCRIPTS) version.in

