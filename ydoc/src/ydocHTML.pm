#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
package kdocHTML;

## KDOC HTML output
#
# From main:
# children classRef classSource dontDoPrivate 
# generatedByText headerList quiet

require Ast;

BEGIN 
{
	$lib = "";
	$outputdir = ".";
	$linkRef = 0;
	$modname = "kdocHTML";
}


sub dumpDoc
{
	$genText = $main::generatedByText;
	$footer_1 = '<TABLE WIDTH="100%"><TR><TD ALIGN="left" VALIGN="top"><i>YaST2 Developers Documentation: </i><b>';
	$footer_2 = '</b></TD><TD ALIGN="RIGHT" VALIGN="TOP"><img src="/usr/share/doc/packages/ydoc/images/yast2-mini.png"></TD></TR></TABLE>';

	($lib, $root, $outputdir) = @_;

	print "Generating HTML documentation.\n" unless $main::quiet;
	writeList();
	writeHeir();
	writeIntro();

#	print "Generating HTMLized headers.\n" unless $main::quiet;
#	foreach $header ( @main::headerList ) {
#		markupCxxHeader( $header );
#	}

}

sub escape
  {
    my( $str ) = @_;
    
    $str =~ s/&/\&amp;/g;
    $str =~ s/</\&lt;/g;
    $str =~ s/>/\&gt;/g;
    $str =~ s/"/\&quot;/g; #"Make emacs happy
      
      return $str;
  } 

sub writeIntro()
  {
    if ( $main::intro eq "" ) { return; }

    open ( INTRO, ">".$outputdir."/intro.html" )
      || die "Couldn't write to ".$outputdir."/intro.html" ;
    print "Creating intro.html...";

    print INTRO<<EOF;
<HTML><HEAD><TITLE>$lib Class Index</TITLE></HEAD><BODY bgcolor="#c8c8c8">
$footer_1 $lib Introduction $footer_2<hr>
<TABLE><TR>
<td valign=top align=center><img src="/usr/share/doc/packages/ydoc/images/yast2-half.png"><br><br><center><a href="index.html">Class index</a><br><A HREF="heir.html">Hierarchy</A><br><font color="606060">Introduction</font></center></td>
<TD VALIGN=TOP><TD VALIGN=TOP><H1>$lib Introduction</H1>

<TABLE BORDER="0" WIDTH="100%">
EOF

  print INTRO makeReferencedText($main::intro);
  print INTRO<<EOF;
</TABLE>
</td></tr></table>
<HR>
$footer_1 $lib Introduction $footer_2
</BODY></HTML>
EOF
}

	      
sub writeList()
{
	open ( LIBIDX, ">".$outputdir."/index.html" )
		|| die "Couldn't write to ".$outputdir."/index.html" ;

	print LIBIDX<<EOF;
<HTML><HEAD><TITLE>$lib Class Index</TITLE></HEAD><BODY bgcolor="#c8c8c8">
$footer_1 $lib Class Index $footer_2<hr>
<TABLE><TR>
<td valign=top align=center><img src="/usr/share/doc/packages/ydoc/images/yast2-half.png"><br><br><center><font color="#606060">Class index</font><br><A HREF="heir.html">Hierarchy</A><br><a href="intro.html">Introduction</a></center></td>
<TD VALIGN=TOP>
	<H1>$lib Class Index</H1>

<TABLE BORDER="0" WIDTH="100%">
EOF

	$root->Visit( $modname );

	foreach $class ( @{$classes} ) {
		$class->Visit( $modname );
		$className = $astNodeName;


		print LIBIDX "<TR><TD ALIGN=\"LEFT\" VALIGN=\"TOP\">",
		"<a href=\"", $astNodeName, ".html\">",
		$astNodeName, "</a></TD>\n", "\t<TD>", 
		makeReferencedText( $ClassShort ), "</TD></TR>\n";	

		writeClass();

		Ast::UnVisit();
	}

	Ast::UnVisit();

print LIBIDX<<EOF;
</TABLE>
</td></tr></table>
<HR>
$footer_1 $lib Class Index $footer_2
</BODY></HTML>
EOF

}

###########################################################
#
# Function
#  makeReferencedText( text )
#
###########################################################

sub makeReferencedText
{
    local( $t ) = @_;

    while ( $t =~ /(\@ref\s+)([\w_\#~\d\:]+\W)/ )
    {
	$pat = $1.$2;
	$ref = $2;
	chop $ref;
	$repl = findClassReference( $ref ) . " ";
#	print  "$ref ---> $repl\n";
	$t =~ s/$pat/$repl/;
    }

    return $t;
}

###########################################################
#
# Function
#  findClassReference( class )
#
###########################################################

sub findClassReference
{
    local( $c ) = @_;
    local( $old );


    if ( $c eq "" ) { return ""; }
    if ( $c eq "#" ) { return "#"; }

    $c =~ s/\:\:/\#/g;

    $old = $c;

    if ( $c =~ /^\s*(\#|::)(.*)$/ )
    {
	$c = "$className\:\:$2";
	$old =~ s/\#//;
    }

    if ( !defined $main::classRef{ $c } )
      {
	if ( !defined $noErr{ $c } )
	{
#	    print "$filename: '$c' undefined Reference\n\n"; 
	}
	return $c;
    }
    else
    {
	if ( $c =~ /\:\:/ )
	{
	    return "<a href=\"".$main::classRef{ $c }."\">$old</a>";
	}
	else
	{
	    return "<a href=\"".$main::classRef{ $c }."\">$c</a>";
	}
    }
}

sub writeHeir
{

open( HEIR, ">".$outputdir."/heir.html" ) 
	||die "Cannot write to $outputdir/heir.html";

print HEIR <<EOF;
<HTML><HEAD><TITLE>$lib Class Hierarchy</TITLE></HEAD>
<BODY BGCOLOR="#c8c8c8">
$footer_1 $lib Class Hierarchy $footer_2
<hr>
<table><tr>
<td valign=top align=center><img src="/usr/share/doc/packages/ydoc/images/yast2-half.png"><br><br><center><a HREF="index.html">Class index</A><br><font color="606060">Hierarchy
<br><a href="intro.html">Introduction</a>
</center></td>
<td valign=top>
<H1>$lib Class Heirarchy</H1>

EOF

printHeirarchy( "<>" );

print HEIR<<EOF;
</td></tr></table>
<HR>
$footer_1 $lib Class Hierarchy $footer_2
</BODY></HTML>
EOF

}

sub printHeirarchy
{
	local( $node ) = @_;
	local( @kids );

	print HEIR "\t<LI>", findClassReference($node),"\n" if $node ne "<>";
	if( defined $main::classSource{ $node } ) {
		print HEIR "<small> (",$main::classSource{ $node}.")</small>\n";
	}


	if ( defined $main::children{$node} ) {
	
		print HEIR "\t<UL>\n";

	        foreach $kid ( sort split /;/, $main::children{$node} )
	        {
	                printHeirarchy( $kid );
		}
		print HEIR "\t</UL>\n";
       	 }

	 print HEIR "\t</LI>" if $node ne "<>";
}

sub writeClass()
{
	open( CLASS, ">".$outputdir."/".$astNodeName.".html" ) || die 
		"Couldn't write to file ".$outputdir."/".$astNodeName.".html";


	print CLASS<<EOF;
<HTML><HEAD><TITLE>$astNodeName</TITLE></HEAD>
<BODY bgcolor="#c8c8c8">
$footer_1 Class $astNodeName $footer_2
<hr>
<table width="100%"><tr>
<td valign=top align=center><img src="/usr/share/doc/packages/ydoc/images/yast2-half.png"><br><br><center><a HREF="index.html">Class index</A><br><A HREF="heir.html">Hierarchy</A><br><a href="intro.html">Introduction</a></center></td>
<td width="100%" valign=top>
<table cellspacing=0 BGCOLOR="#f96500" width="100%"><tr><td>
<table width="100%" bgcolor="#ffc080" cellpadding=10><TR><TD>
<P><H1><font color="#e00000">$astNodeName</font></H1>
EOF

	print CLASS makeReferencedText( $ClassShort );

	$_ = $Header;
	s/-/--/g;
	s/\/|\./-/g;
	$escapedpath = $_;

# include file

	print CLASS<<EOF;
</td></tr><tr><td><p>
EOF
#<code>
#	#include &lt;<a href=\"$escapedpath.html\">$Header</a>&gt;
#</code>\n
#</P>

# Inheritance
	my ( $pcount ) = 0;

	if( defined $class->{ "Ancestors" } ) {
		print CLASS "\n<P>\nInherits: ";
		
		foreach $foreparent ( @{$Ancestors} ) {
			print CLASS ", " if $pcount != 0;
			$pcount = 1;

			print CLASS findClassReference( 
				$foreparent->{"astNodeName"} );

			if( defined $main::classSource{$foreparent->{
					"astNodeName"}} ) {
				print CLASS " (",$main::classSource{
					$foreparent->{"astNodeName"}},")";
			}
		}

		print CLASS "\n<\P>";
	}
# Now list members.

	$linkRef = 0;

	listMethods( "Public Members", $public );
	listMethods( "Public Slots", $public_slots );
	listMethods( "Protected Members", $protected );
	listMethods( "Protected Slots", $protected_slots );
	listMethods( "Signals", $signals );

	if( $main::dontDoPrivate == 0 ) {
		listMethods( "Private Members", $private );
		listMethods( "Private Slots", $private_slots );
	}
print CLASS<<EOF;
</td></tr></table>
</td></tr></table>
</TD></TR></TABLE>
EOF

# Dump Description.
	Ast::UnVisit();
	$class->Visit($modname);
	writeClassDescription();

# Document members.
	
	$linkRef = 0;

	writeMemberDoc( $public );
	writeMemberDoc( $public_slots );
	writeMemberDoc( $protected );
	writeMemberDoc( $protected_slots );
	writeMemberDoc( $signals );

	if( $main::dontDoPrivate == 0 ) {
		writeMemberDoc( $private );
		writeMemberDoc( $private_slots );
	}

            print CLASS<<EOF;
<hr>
$footer_1 Class $astNodeName $footer_2
</BODY></HTML>\n
EOF

}

######
# Lists all methods of a particular visibility.
#####

sub listMethods()
{
	my( $desc, $members ) = @_;
	
	return if !defined $members || $#{$members} == -1;

print CLASS<<EOF;

<H2><font color="#f06000">$desc</font></H2>
<UL>
EOF

	foreach $member ( @{$members} ) {
		$member->Visit($modname);

		print CLASS "<LI>";

		if( $Description eq "" && $See eq "" ) {
			$link = "name=\"";
		} else {
			$link = "href=\"\#";
		}

		if( $Keyword eq "property" ) {
			print CLASS escape($Type), 
				"<b><a ",$link,"ref$linkRef\">",
				escape($astNodeName), "</a></b>\n";
		}
		elsif( $Keyword eq "method" ) {
			print CLASS escape($ReturnType),
				"<b><a ", $link, "ref$linkRef\"><font color=\"#c05000\">",
				escape($astNodeName), "</font></a></b> (",
				escape($Parameters),
				") ",$Const,"\n";
		}
		elsif( $Keyword eq "enum" ) {
			print CLASS "enum <b><a ", $link, "ref$linkRef\">",
				escape($astNodeName),"</a></b> {",
				escape($Constants),"}\n";
		}

		print CLASS "</LI>\n";

		$linkRef += 1;

		Ast::UnVisit();
	}

print CLASS<<EOF;
</UL>
EOF

}

sub writeClassDescription
{
	if( $Description ne "" ) {
		print CLASS "<H2><a name=\"short\">Detailed Description</a>",
			"</H2>\n<P>\n";

		$Description =~ s/\n\n+/\n<\/p><p>\n/g;
		print CLASS "<p>",makeReferencedText($Description) ,"</p>\n";
EOF
	}
	
}

sub writeMemberDoc
{
	my( $node ) = @_;

	return if !defined $node || $#{$node} == -1 ;

	foreach $member ( @{$node} ) {
		$member->Visit($modname);

		if( $Description eq "" && $See eq "" ) {
			$linkRef++;
			Ast::UnVisit();
			next;
		}
		print CLASS "<table border=0 cellspacing=0 width=\"100%\" bgcolor=\"#f96500\" cellpadding=1><tr><td><table width=\"100%\" bgcolor=\"#ffc080\" cellspacing=0 cellpadding=3 border=0><tr><td>\n";

		print CLASS "<font size=\"+1\"><tt><b>";
			
		if( $Keyword eq "property" ) {
			print CLASS refString(escape($Type)), 
			"<a name=\"ref",$linkRef,"\"></a>", 
			"<a name=\"",$astNodeName,"\">", 
			escape($astNodeName), "</a></b></tt></font>\n";	
		}
		elsif( $Keyword eq "method" ) {
			print CLASS refString(escape($ReturnType)), 
			"<a name=\"ref",$linkRef,"\"></a>", 
			"<a name=\"",$astNodeName,"\"><font color=\"#c05000\">", 
			escape($astNodeName), "</font></a>(",
			refString(escape($Parameters)),") $Const </b></tt></font>\n";	
		}
		elsif( $Keyword eq "enum" ) {
			print CLASS "enum <a name=\"ref", $linkRef,"\"></a>",
			"<a name=\"",$astNodeName, "\"></a>",
			escape($astNodeName), " (",
			$Constants,")</b></tt></font>\n";
		}
		printf CLASS "</td></tr></table></td></tr></table>";

		$Description =~ s/\n\n+/\n<\/p><p>\n/g;

		print CLASS "<p>",makeReferencedText($Description),"</p>\n";
		

		if( $Keyword eq "method" ) {

			if( $#{$ParamDoc} != -1 ) {
				print CLASS "<dl><dt><b>Parameters</b>:<dd>\n",
					"<table width=\"100%\" border=\"0\">\n";

				foreach $parameter ( @{$ParamDoc} ) {
					print CLASS 
					"<tr><td align=\"left\" valign=\"top\">\n",
					$parameter->{"astNodeName"};

					print CLASS
					"</td><td align=\"left\" valign=\"top\">\n",
					makeReferencedText(
					$parameter->{"Description"}),
					"</td></tr>\n";
				}

				print CLASS "</table>\n</dl>\n";

			}


			print CLASS "<dl><dt><b>Returns</b>:<dd>\n",
				makeReferencedText( $Returns ),
				"</dl>\n" if $Returns ne "";
		}

		if( $See ne "" ) {
			print CLASS "<dl><dt><b>See Also</b>:<dd>";
			
			foreach $item ( split /[\s,]+/,$See ) {
				print CLASS findClassReference( $item ); 
			}

			print CLASS "</dl>\n";
		}

		Ast::UnVisit();

		$linkRef++;
	}
}

#
# Check and markup words that are in the symbol table.
# Use sparingly, since EVERY WORD is looked up in the table.
#

sub refString
{
	my( $source ) = @_;
	$old = "";
	foreach $werd ( sort split /[^\w><]+/, $source ) {
	  if ($old ne $werd ) {
	    $ref = findClassReference( $werd );
	    if( $ref ne $werd ) {
	      $source =~ s/$werd/$ref/g;
	    }
	  }
	  $old = $werd
	}

	return $source;
}

######################################################################
# markupCxxHeader -- Converts the header into a semi-fancy HTML doc
######################################################################

$outputFilename = "";

# tokens
$nonIdentifier="[^\w]+";
$keywords="if|union|class|struct|operator|for|while|do|goto|new|delete|friend|typedef|return|switch|const|inline|asm|sizeof|virtual|static";
$types="void|int|long|float|double|unsigned|char|bool|short";

# styles
$keywordStyle="strong";
$typeStyle="u";
$stringStyle="i";

# Takes the path to a C++ source file,
# spits out a marked-up and cross-referenced HTML file.

sub markupCxxHeader
{
	my( $filename ) = @_;
	my( $className ) = "";
	my( $reference );
	my( @inheritance );
	my( $word );

	open( HFILE, $filename ) || die "Couldn't open $filename to read.\n";

	$_ = $filename;
	# convert dashes to double dash, convert path to dash
	s/-/--g/g;
	s/\/|\./-/g;
	$outputFilename = $_;
	$outputFilename = $outputdir."/".$outputFilename;

	 open( HTMLFILE, ">$outputFilename.html" ) 
		|| die "Couldn't open $outputFilename to read.\n";

	print HTMLFILE "<HTML>\n<HEAD><TITLE>$outputFilename</TITLE></HEAD>\n".
		"<BODY BGCOLOR=\"#ffffff\">\n<PRE>";

	while( <HFILE> )
	{

		s/</\&lt;/g;
		s/>/\&gt;/g;
		s/"/\&quot;/g;

		if( /^\s*(template.*\s+)?(class|struct)/ ) {
			$_ = refString($_);
		}

		print HTMLFILE;
	}

	print HTMLFILE "</PRE>\n<HR>\n<address>$genText",
			"</address>\n</BODY>\n</HTML>\n";
}

1;
