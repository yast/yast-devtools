#!/usr/bin/perl

my %action = ();
my %options = ();

#load defaults


init_options(\%action,\%options, \@ARGV);
my $val = run(\%action,\%options);
exit( $val);



#
# paring options and setting defaults
#
sub init_options($$$) {
	my ($action,$options, $args) = @_;
	$action->{'--add'} = undef;
	$action->{'--delete'} = undef;
	$action->{'--find'} = undef;
	
	if ( exists( $action->{$args->[0]} ) ) {
		 $action->{$args->[0]} = 1;
	}
	else {
		printf STDERR "unknown option: $args->[0]\n";
		exit 1; 
	}
	$options->{'--service'} = undef;
	$options->{'--port'} = '50001';
	$options->{'--proto'} = 'tcp';
	$options->{'--reverse'} = undef;
	if ( defined ($action->{'--find'}) ) {
	  $options->{'--port'} = undef;
	}
	$options->{'--file'} = '/etc/services';
	for (my $i = 1; $args->[$i]; $i++) {
		#print $i,":",$args->[$i],":",$args->[$i],"\n";
		if ( exists( $options->{$args->[$i]} )  && $args->[$i] ne '--reverse') {
		  $options->{$args->[$i]} = $args->[$i + 1] ;
		  $i++;
		  
        	}
		else if ($args->[$i] eq '--reverse') {
		  $options->{$args->[$i]} = 1;
		}
        	else {
                	print STDERR unknown option: $args->[$i];
			exit 1
        	}
	}
}

sub run($$) {
	my ($action,$options) = @_;
	
	if ( defined($action->{'--add'}) ) { 
		return run_add($options);
	}
	elsif ( defined($action->{'--delete'}) ) {
                return run_delete($options);
        }
	elsif ( defined ($action->{'--find'}) ) {
                return run_find($options);
        }
	
}

sub run_add($) {
	my ($options) = @_;
	
	# we need all possible options
	if (!defined($options->{'--service'}) ||
		!defined($options->{'--proto'}) ||
		!defined($options->{'--port'}) ) {
		printf STDERR "you have to define at least the service\n";
		print $options->{'--service'},"\n";
		exit 1;
	}		
	
	open(FH,"<$options->{'--file'}") || die("Can't open file $options->{'--file'}",);
	my @lines = <FH>;
	close(FH);
	
	foreach my $line (@lines) {
		if ( $line =~ /^\s*$options->{'--service'}\s+$options->{'--port'}\/$options->{'--proto'}/ ) {
			print STDERR "service \'$options->{'--service'}\' and port already  exists:\n$line\n";
			exit 1;
		}	
		if ( $line =~ /^\s*$options->{'--service'}\s/ ) {
			print STDERR "service \'$options->{'--service'}\' exists:\n$line\n";
			exit 1;
		}
		if ( $line =~ /\s+$options->{'--port'}\/$options->{'--proto'}/ ) {
			print STDERR " port \'$options->{'--port'}\' already  exists:\n$line\n";

			exit 1;
		}
	}
	my $temp = sprintf("%s.%d.bak", $options->{'--file'},time);
	#print $temp,"\n"; 
	use File::Copy;
	if (! copy( $options->{'--file'}, $temp) ) {
		printf STDERR "Can't create backup file $temp. Exit now!\n";
		exit 1;
	}
	if (!open(FH,">$options->{'--file'}")) {
		print STDERR "Can't open $options->{'--file'} for writing! Exit now!\n";
	}
	print FH @lines;
	print FH $options->{'--service'},"\t",$options->{'--port'},"/",$options->{'--proto'},"\n";
	close FH;
	#print @lines;

	return 0;
}

sub run_delete($) {
        my ($options) = @_;
	if (!defined($options->{'--port'}) ) {
	  printf STDERR "you have to define at least the port\n";
	  print $options->{'--service'},"\n";
	  exit 1;
	}		
	
	open(FH,"<$options->{'--file'}") || die("Can't open file $options->{'--file'}",);
	my @lines = <FH>;
	close(FH);
	
	## creating a backup
	my $temp = sprintf("%s.%d.bak", $options->{'--file'},time);
	#print $temp,"\n"; 
	use File::Copy;
	if (! copy( $options->{'--file'}, $temp) ) {
		printf STDERR "Can't create backup file $temp. Exit now!\n";
		exit 1;
	}
	if (!open(FH,">$options->{'--file'}")) {
		print STDERR "Can't open $options->{'--file'} for writing! Exit now!\n";
	}
	foreach my $line (@lines) {
	  if($options->{'--service'} && $options->{'--port'} && $options->{'--proto'} ) {
	    if ($line =~ /^\s*$options->{'--service'}\s+$options->{'--port'}\/$options->{'--proto'}/ ) {  
	    }
	    else {
	      print FH $line;
	    }
	  }
	  elsif($options->{'--service'} && !$options->{'--port'} && !$options->{'--proto'} ) {
	    if ( $line =~ /^\s*$options->{'--service'}\s/ ) {
	    }
	    else {
	      print FH $line;
	    }
	  }
	  elsif(!$options->{'--service'} && $options->{'--port'} && $options->{'--proto'} ) {
	    if ( $line =~ /\s+$options->{'--port'}\/$options->{'--proto'}/ ) {
	    }
	    else {
	      print FH $line;
	    }
	  }
	  else {
	    print STDERR "Check your Options for deleting. Exit now!\n";
	    exit 1;
	  }
	}
	close FH;
	
	#print @lines;

	return 0;
}
	

sub run_find($) {
  my ($options) = @_;
  open(FH,"<$options->{'--file'}") || die("Can't open file $options->{'--file'}",);
  my @lines = <FH>;
  close(FH);
  foreach my $line (@lines) {
    if($options->{'--service'} && $options->{'--port'} && $options->{'--proto'} ) {
      if ($line =~ /^\s*$options->{'--service'}\s+$options->{'--port'}\/$options->{'--proto'}/ ) {
	print STDOUT $line;
	if(defined($options->{'--reverse'}) ) {
	  return 0;
	}
	return 1;
      }
    }
    elsif($options->{'--service'} && !$options->{'--port'} && !$options->{'--proto'} ) {
      if ( $line =~ /^\s*$options->{'--service'}\s/ ) {
	print STDOUT $line;
	if(defined($options->{'--reverse'}) ) {
	  return 0;
	}
	return 1;
      }
    }
    elsif($options->{'--service'} && !$options->{'--port'} && $options->{'--proto'} ) {
      if ( $line =~ /^\s*$options->{'--service'}\s/ ) {
	print STDOUT $line;
	if(defined($options->{'--reverse'}) ) {
	  return 0;
	}
	return 1;
      }
    }
    elsif(!$options->{'--service'} && $options->{'--port'} && $options->{'--proto'} ) {
      if ( $line =~ /\s+$options->{'--port'}\/$options->{'--proto'}/ ) {
	print STDOUT $line;
	if(defined($options->{'--reverse'}) ) {
	  return 0;
	}
	return 1;
      }
    }
    else {
      print STDERR "Check your Options for finding. Exit now!\n";
      exit 1;
    }
  }
  
  if(defined($options->{'--reverse'}) ) {
    return 1;
  }
  return 0;
}		
		 






