#
# Makefile.am for devtools/yast2
#

# bnc#396315 
pkgdatadir = @YAST2DEVTOOLS@/bin
pkgdata_SCRIPTS = ycp_puttext
install-data-local:
	ln -snf $(pkgdatadir)/ycp_puttext $(DESTDIR)$(ybindir)

emacsdir = $(prefix)/share/emacs/site-lisp
emacs_DATA = ycp-mode.el suse-start-ycp-mode.el

vimsyntaxdir = $(prefix)/share/vim/site/syntax
vimsyntax_DATA = ycp.vim

vimftdir = $(prefix)/share/vim/site/ftdetect
vimft_DATA = ycp_filetype.vim

client_DATA = ycp2yml.rb create_maintenance_branch.rb

EXTRA_DIST = $(pkgdata_SCRIPTS) $(emacs_DATA) $(vimsyntax_DATA) $(vimft_DATA) $(client_DATA)
