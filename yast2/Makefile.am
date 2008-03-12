#
# Makefile.am for devtools/yast2
#

SUBDIRS = check_ycp

ybin_SCRIPTS = ycp_puttext

emacsdir = $(prefix)/share/emacs/site-lisp
emacs_DATA = ycp-mode.el suse-start-ycp-mode.el

vimsyntaxdir = $(prefix)/share/vim/site/syntax
vimsyntax_DATA = ycp.vim

vimftdir = $(prefix)/share/vim/site/ftdetect
vimft_DATA = ycp_filetype.vim

EXTRA_DIST = $(ybin_SCRIPTS) $(emacs_DATA) $(vimsyntax_DATA) $(vimft_DATA)
