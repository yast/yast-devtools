#
# Makefile.am for devtools/devtools/skeletons
#

skeletonsdir = $(DESTDIR)@YAST2DEVTOOLS@/skeletons

# install the skeletons
install-data-local:
	mkdir --parents $(skeletonsdir); \
	echo $(srcdir); \
	ls; \
	cd $(srcdir); \
	for D in `ls` ; \
	do \
	    if [ -d $$D -a "$$D" != "CVS" -a "$$D" != ".deps" ] ; \
	    then \
		echo "Removing old $(skeletonsdir)/$$D and installing new one..." ; \
		rm -rf $(skeletonsdir)/$$D ; \
		find $$D \
		     -type f -and -not -path "*CVS*" \
			     -and -not -path "*.deps*" \
		             -and -not -path "*~" \
		     -exec cp --parents {} $(skeletonsdir) \; ; \
	    fi ; \
	done

# copy the skeletons to the package
dist-hook:
	distdir=`cd $(distdir) && pwd`; \
	cd $(srcdir); \
	ls; \
	for D in `ls` ; \
	do \
	    if [ -d $$D -a "$$D" != "CVS" -a "$$D" != ".deps" ] ; \
	    then \
		find $$D \
		     -type f -and -not -path "*CVS*" \
			     -and -not -path "*.deps*" \
		             -and -not -path "*~" \
		     -exec cp --parents {} $${distdir} \; ; \
	    fi ; \
	done
