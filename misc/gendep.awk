BEGIN	{
	    module = "";
	}

/module[ ]*"[^"]*";/	{
	 split ($0, x, "\"");
	 if (module != "") {
	   print "DUPLICATE module";
	   exit;
	 }
	 module = x[2];
	 printf ("%s:", module);
	}
/import[ ]*"[^"]*";/	{
	 if (module != "") {
	   split ($0, x, "\"");
	   printf (" %s", x[2]);
	 }
	}
END	{
	 if (module != "") {
	   print "";
	 }
	}
