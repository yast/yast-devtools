#
# Makefile.am for devtools/y2log_ana
#

if CHECK_QT4
Y2L = y2log_ana 
else
Y2L =
endif

INCLUDES = $(Qt4_CFLAGS) -I.

noinst_PROGRAMS		= $(Y2L)

METASOURCES = AUTO

y2log_ana_LDFLAGS = $(all_libraries)

y2log_ana_LDADD = $(Qt4_LIBS)

y2log_ana_SOURCES	= cgui.cc	\
			  cgui.h	\
				 	 cman.cc	\
				 	 cy2log.cc	\
				 	 cy2log.h	\
           cgui.moc.cc

%.moc.cc: %.h
		$(MOC) $< -o $@

CLEANFILES = *.moc.cpp
