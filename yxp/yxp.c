#include <libxml/tree.h>
#include <stdlib.h>
#include <string.h>

xmlDocPtr thedoc;
xmlNodePtr rootnode;

extern int yyparse();
extern int yydebug;
extern int ignore_ws;

int main (int argc, char **argv) {
  int result;
  ignore_ws = (argc > 1 && strcmp (argv[1], "--nows") == 0);

  thedoc = xmlNewDoc("1.0");
  yydebug = !!getenv("YXPDEBUG");
  result = yyparse ();
  xmlSaveFormatFile("-", thedoc, !!getenv("YXPFORMAT"));
  return result;
}
