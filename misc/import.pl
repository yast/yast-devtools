#! /usr/bin/perl -w
# parameters: any ycp files. (eg find . -name \*.ycp)
use strict;
my $current;
my $current_file = "";
while (<>)
{
    if (m/^\s*module\s*"(.*)";/)
    {
	$current = $1;
	$current_file = $ARGV;
    }
    elsif (m/^\s*import\s*"(.*)";/)
    {
	if ($current_file eq $ARGV)
	{
	    print " \"$current\" -> \"$1\" // $current_file\n";
	}
    }
}
