#
# Makefile.am for devtools/y2log_ana
#

INCLUDES = $(PACKAGE_CFLAGS) 

noinst_PROGRAMS		= y2log_ana

METASOURCES = AUTO

y2log_ana_LDFLAGS = $(all_libraries)

y2log_ana_LDADD = $(PACKAGE_LIBS)

y2log_ana_SOURCES	= cgui.cc	\
				 	 cman.cc	\
				 	 cy2log.cc	\
				  	moc_cgui.cc
