#
# Makefile.am for devtools/devtools/skeletons/agent/src
#

plugin_LTLIBRARIES = libpy2ag_XXpkgXX.la
noinst_LTLIBRARIES = liby2ag_XXpkgXX.la

liby2ag_XXpkgXX_la_SOURCES =                    \
	XXPkgXXAgent.cc		\
	XXPkgXXAgent.h
liby2ag_XXpkgXX_la_LDFLAGS = -version-info 2:0

libpy2ag_XXpkgXX_la_SOURCES =                           \
        $(liby2ag_XXpkgXX_la_SOURCES)                   \
        Y2CCXXPkgXXAgent.cc         Y2CCXXPkgXXAgent.h
libpy2ag_XXpkgXX_la_LDFLAGS = -version-info 2:0

INCLUDES = -I$(includedir)

