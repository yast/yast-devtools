#! /usr/bin/perl
# parameters: none
use strict;
use warnings;
use diagnostics;
use IO qw(File);

# prevent include cycles :-(
#my %includes;


# scans $pathname for import statements, processing includes
# pathname - current file
# includes - what include files are open
sub get_imports ($$);
sub get_imports ($$)
{
    my ($pathname, $r_includes) = @_;
    my @result;

    print STDERR " I $pathname\n";

    # has this one been processed?
    if ($r_includes->{$pathname})
    {
	print STDERR "  Cycle! Returning.\n";
	return ();
    }

    my $F = new IO::File ($pathname);
    # we have seen it already
    $r_includes->{$pathname} = 1;

    while (defined ($_ = <$F>))
    {
	if (m/^\s*import\s*"(.*)";/)
	{
	    push @result, $1;
	}
	elsif (m/^\s*include\s*"(.*)";/)
	{
	    my $inc = "/usr/share/YaST2/include/$1";
	    push (@result, get_imports ($inc, $r_includes));
	}
    }
    $F->close ();
    delete $r_includes->{$pathname};
    return @result;
}

# what should be output
my ($modgraph, $clusters) = (0, 0);
my $pkggraph = 1;

print "digraph \"import\" {\n";
print "rankdir=LR;\n";
print "size=\"16,11\"; rotate=90;\n";
my %pkg2mod = (); # hash of lists
my %mod2pkg = (); # hash of strings
my %dep = (); # hash of lists
foreach (glob ("/usr/share/YaST2/modules/*.ycp"))
{
    my $module = $_;
    my $rpm = `rpm -qf --qf \%{name} $module`;
#    chomp $rpm;
#    $rpm =~ s/[0-9.-]*$//; 
    chomp $rpm;
    $module =~ s:.*/(.*)\.ycp:$1:;
    print STDERR "M $module\n";
    print STDERR "P $rpm\n";
    $mod2pkg{$module} = $rpm;
    push @{$pkg2mod{$rpm}}, $module;

    # reset before processing includes
#    %includes = ();
    my @imported = get_imports ($_, {});
    foreach my $i (@imported)
    {
	push @{$dep{$module}}, $i;
    }
}

while (my ($module, $deps_r) = each %dep)
{
    foreach (@{$deps_r})
    {
	print "  \"$module\" -> \"$_\"\n" if $modgraph;
	print "  \"$mod2pkg{$module}\" -> \"$mod2pkg{$_}\"\n" if $pkggraph;
    }
}

print "\n";
# rpm clusters
if ($clusters)
{
  while (my ($pkg, $modules_r) = each %pkg2mod)
  {
    print "  subgraph \"cluster-$pkg\" {\n";
    foreach (@{$modules_r})
    {
	print "    \"$_\";\n";
    }
    print "  }\n";
  }
}
print "}\n";
