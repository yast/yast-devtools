#
# Makefile.am for the skeletons.
#
# $Id$
#

skeletonsdir = @YAST2DEVTOOLS@/skeletons

# install the skeletons
install-data-local:
	mkdir --parents $(skeletonsdir) ; \
	distdir=`cd $(distdir) && pwd`; \
	cd $(srcdir); \
	for D in `ls` ; \
	do \
	    if [ -d $$D -a "$$D" != "CVS" ] ; \
	    then \
		echo "Removing old $(skeletonsdir)/$$D and installing new one..." ; \
		rm -rf $(skeletonsdir)/$$D ; \
		find $$D \
		     -type f -and -not -path "*CVS*" -and -not -path "*~" \
		     -exec cp --parents {} $(skeletonsdir) \; ; \
	    fi ; \
	done

# copy the skeletons to the package
dist-hook:
	distdir=`cd $(distdir) && pwd`; \
	cd $(srcdir); \
	for D in `ls` ; \
	do \
	    if [ -d $$D -a "$$D" != "CVS" ] ; \
	    then \
		find $$D \
		     -type f -and -not -path "*CVS*" -and -not -path "*~" \
		     -exec cp --parents {} $${distdir} \; ; \
	    fi ; \
	done
