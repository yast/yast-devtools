YACC=bison
YFLAGS=--verbose --defines --debug --token-table
LEX=flex
LFLAGS=-s
CFLAGS=-g -Wall `xml2-config --cflags`
LDFLAGS=-g
LOADLIBES=-lfl `xml2-config --libs`

yxp: yxp.o yxp.tab.o yxp.lex.o
yxp.c:
	echo duh

%.tab.c %.tab.h: %.y
	$(YACC) $(YFLAGS) $<
%.lex.c: %.fl %.tab.h
	$(LEX) $(LFLAGS) -o$@ $<
clean:
	-rm *.tab.* *.lex.*
.SECONDARY: yxp.lex.c yxp.tab.c
