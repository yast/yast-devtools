#! /usr/bin/perl

=head1 NAME

import.pl - makes graphs of YaST dependencies

=head1 SYNOPSIS

  import.pl -h|--help|--man
  import.pl {--modules [--clusters] | --packages} [--y2dir <y2dir>] [--topdown]

=head1 AUTHOR

Martin Vidner <mvidner@suse.cz>

=cut

use strict;
use warnings;
use diagnostics;
use IO qw(File);
use Getopt::Long;
use Pod::Usage;

my $help = 0;
my $man = 0;
# what should be output
my ($modgraph, $clusters) = (0, 0);
my $pkggraph = 0;
my $y2dir = "/usr/share/YaST2";
my $topdown = 0;

Getopt::Long::Configure ("bundling");
GetOptions (
	    "help|h" => \$help,
	    "man" => \$man,
	    "modules|m" => \$modgraph,
	    "clusters|c" => \$clusters,
	    "packages|p" => \$pkggraph,
	    "y2dir|d=s" => \$y2dir,
	    "topdown|t" => \$topdown,
	   ) or pod2usage (2);
pod2usage (1) if $help;
pod2usage (-exitstatus => 0, -verbose => 2) if $man;

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

    my $F = new IO::File ($pathname) or die "Cannot open $pathname: $!";
    # we have seen it already
    $r_includes->{$pathname} = 1;

    while (defined ($_ = <$F>))
    {
	# YCP import
	if (m/^\s*import\s*"(.*)";/)
	{
	    push @result, $1;
	}
	# Perl import
	elsif (m/^\s*YaST::YCP::Import\s*\(?\s*"(.*)"\)?;/)
	{
	    push @result, $1 unless ($1 eq "SCR");
	}
	elsif (m/^\s*include\s*"(.*)";/)
	{
	    my $inc = "$y2dir/include/$1";
	    push (@result, get_imports ($inc, $r_includes));
	}
    }
    $F->close ();
    delete $r_includes->{$pathname};
    return @result;
}

print "digraph \"import\" {\n";
print "rankdir=LR;\n" unless ($topdown);
print "size=\"16,11\"; rotate=90;\n";
my %pkg2mod = (); # hash of lists
my %mod2pkg = (); # hash of strings
my %dep = (); # hash of lists
foreach (glob ("$y2dir/modules/{*,*/*}.{ycp,pm}"))
{
    my $module = $_;
    my $rpm = `rpm -qf --qf \%{name} $module`;
#    chomp $rpm;
#    $rpm =~ s/[0-9.-]*$//; 
    chomp $rpm;
    $module =~ s:$y2dir/modules/(.*)\.[^.]*:$1:;
    $module =~ s{/}{::}g;
    print STDERR "M $module\n";
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
