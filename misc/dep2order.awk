#
# dep2order
# scan deplist and compute order
#
BEGIN	{
	  FS = " ";
	  modnum = 1;
	}
END	{
	  # modlist[] contains all module names */
	  # deplist[module, 0] contains the number of imports in module */
	  # deplist[module, i] contains the i'th import */

	  ordnum = 0;
	  maxdepth = 0;
	  for (m in modlist) {
	    mod = modlist[m];
	    depth = deplist[mod, 0];
	    if (depth == 0) {
	      deplist[mod, 0] = -1;		# mark as 'moved to order'
	      order[ordnum] = mod;
	      ordnum++;
	    }
	    else if (depth > maxdepth) {
	      maxdepth = depth;
	    }
	  }
	  print "Maximum depth " maxdepth;

	  for (depth = 1; depth <= maxdepth; depth++) {		# loop over increasing depth
	    for (m in modlist) {
	      mod = modlist[m];
	      if (deplist[mod, 0] == depth) {			# look at modules with current depth
		deplist[mod, 0] = -1;				# mark as 'moved to order'
		order[ordnum] = mod;
		ordnum++;
	      }
	    }
	  }

	  for (o = 0; o < ordnum; o++) print order[o];
	}
	{	/* module: import import ... */
	  l = length ($1);
	  module = substr ($1, 1, l-1);
	  modlist[modnum] = module;
	  modnum++;
	  deplist[module, 0] = NF-1;
	  if (NF > 1) {
	    for (i = 2; i <= NF; i++) {
	      deplist[module, i-1] = $i;
	    }
	  }
	}

