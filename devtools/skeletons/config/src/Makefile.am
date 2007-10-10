# Makefile.am for XXpkgXX/src

yncludedir = @yncludedir@/XXpkgXX

client_DATA =			\
	XXpkgXX.ycp		\
	XXpkgXX_auto.ycp	\
	XXpkgXX_proposal.ycp

ynclude_DATA =			\
	helps.ycp		\
	wizards.ycp		\
	dialogs.ycp		\
	complex.ycp

desktop_DATA =			\
	XXpkgXX.desktop

module_DATA =			\
	XXPkgXX.ycp		\
	XXPkgXX2.pm		\
	XXPkgXX3.py

# create a symlink for local build, #145327
XXpkgXX:
	ln -sf . $@
ycpchook = XXpkgXX

EXTRA_DIST = $(client_DATA) $(ynclude_DATA) $(module_DATA) $(desktop_DATA)

include $(top_srcdir)/Makefile.am.common
