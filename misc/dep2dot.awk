#
# dep2dot.awk
# generate .dot file from deplist
#
# deplist format is:
#
# module: import1 import2 import3 ...
# ...
#
#

BEGIN	{
	  FS = " ";
	  print "digraph yast {";
	  print "rankdir=LR;";
	  print "size=\"64,64\";";
	  print "ratio=fill;";
	  print "node [fontsize=48];";
	}
END	{
	  print ("}");
	}
	{	/* module: import import ... */
	  l = length ($1);
	  module = substr ($1, 1, l-1);
	  printf ("\"%s\";\n", module);
	  if (NF > 1) {
	    for (i = 2; i <= NF; i++) {
	      printf ("\"%s\" -> \"%s\" [dir=forward, arrowhead=normal];\n", module, $i);
	    }
	  }
	}
