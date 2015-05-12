#
# Makefile.am for devtools/yast2
#

# bnc#396315 
pkgdatadir = @YAST2DEVTOOLS@/bin
dist_pkgdata_SCRIPTS =				\
		ycp_puttext			\
		create_maintenance_branch
install-data-local:
	ln -snf $(pkgdatadir)/ycp_puttext $(DESTDIR)$(ybindir)

emacsdir = $(prefix)/share/emacs/site-lisp
dist_emacs_DATA =				\
		ycp-mode.el			\
		suse-start-ycp-mode.el

vimsyntaxdir = $(prefix)/share/vim/site/syntax
dist_vimsyntax_DATA = ycp.vim

vimftdir = $(prefix)/share/vim/site/ftdetect
dist_vimft_DATA = ycp_filetype.vim

dist_client_DATA = ycp2yml.rb
