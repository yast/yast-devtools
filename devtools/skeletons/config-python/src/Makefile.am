# Makefile.am for XXpkgXX/src

yncludedir = @yncludedir@/XXpkgXX

client_DATA =			\
	XXpkgXX.py

#TODO: This must be modified to python can know from where can import!
ynclude_DATA =			\
	helps.py		\
	wizards.py		\
	dialogs.py		\
	complex.py

desktop_DATA =			\
	XXpkgXX.desktop

module_DATA = XXPkgXX.py

# create a symlink for local build, #145327
XXpkgXX:
	ln -sf . $@
ycpchook = XXpkgXX

EXTRA_DIST = $(client_DATA) $(ynclude_DATA) $(module_DATA) $(desktop_DATA)

include $(top_srcdir)/Makefile.am.common
