#
# Makefile.am for .../agent-XXpkgXX/src
#

AM_CXXFLAGS = -DY2LOG=\"agent-XXpkgXX\" -Wall

plugin_LTLIBRARIES = libpy2ag_XXpkgXX.la
noinst_LTLIBRARIES = liby2ag_XXpkgXX.la

liby2ag_XXpkgXX_la_SOURCES =				\
	XXPkgXXAgent.cc					\
	XXPkgXXAgent.h
liby2ag_XXpkgXX_la_LDFLAGS = -version-info 2:0
liby2ag_XXpkgXX_la_LIBADD = @AGENT_LIBADD@

libpy2ag_XXpkgXX_la_SOURCES =				\
        $(liby2ag_XXpkgXX_la_SOURCES)			\
        Y2CCXXPkgXXAgent.cc
libpy2ag_XXpkgXX_la_LDFLAGS = -version-info 2:0
libpy2ag_XXpkgXX_la_LIBADD = @AGENT_LIBADD@

INCLUDES = -I$(includedir)
