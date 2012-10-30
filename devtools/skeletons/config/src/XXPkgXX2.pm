#! /usr/bin/perl -w

# ------------------------------------------------------------------------------
# Copyright (c) 2006 Novell, Inc. All Rights Reserved.
#
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of version 2 of the GNU General Public License as published by the
# Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, contact Novell, Inc.
#
# To contact Novell about this file by physical or electronic mail, you may find
# current contact information at www.novell.com.
# ------------------------------------------------------------------------------

# File:		modules/XXPkgXX.pm
# Package:	Configuration of XXpkgXX
# Summary:	XXPkgXX settings, input and output functions
# Authors:	XXmaintainerXX <XXemailXX>
#
# $Id$
#
# Representation of the configuration of XXpkgXX.
# Input and output routines.


package XXPkgXX;

use strict;

use YaST::YCP qw(Boolean :LOGGING);
use YaPI;

textdomain("XXpkgXX");

our %TYPEINFO;

YaST::YCP::Import ("Progress");
YaST::YCP::Import ("Report");
YaST::YCP::Import ("Summary");
YaST::YCP::Import ("Message");

##
 # Data was modified?
 #
my $modified = 0;

##
 #
my $proposal_valid = 0;

##
 # Write only, used during autoinstallation.
 # Don't run services, it's all done at one place.
 #
my $write_only = 0;

##
 # Data was modified?
 # @return true if modified
 #
BEGIN { $TYPEINFO {Modified} = ["function", "boolean"]; }
sub Modified {
    y2debug ("modified=$modified");
    return Boolean($modified);
}

##
 # Mark as modified, for Autoyast.
 #
BEGIN { $TYPEINFO {SetModified} = ["function", "void", "boolean" ]; }
sub SetModified {
    my $value = $_[1];
    $modified = $value;
}

BEGIN { $TYPEINFO {ProposalValid} = ["function", "boolean"]; }
sub ProposalValid {
    return Boolean($proposal_valid);
}

BEGIN { $TYPEINFO {SetProposalValid} = ["function", "void", "boolean" ]; }
sub SetProposalValid{
    my $value = $_[1];
    $proposal_valid = $value;
}

BEGIN { $TYPEINFO {WriteOnly} = ["function", "boolean"]; }
sub WriteOnly {
    return Boolean($write_only);
}

BEGIN { $TYPEINFO {SetWriteOnly} = ["function", "void", "boolean" ]; }
sub SetWriteOnly{
    my $value = $_[1];
    $write_only = $value;
}


# Settings: Define all variables needed for configuration of XXpkgXX
# TODO FIXME: Define all the variables necessary to hold
# TODO FIXME: the configuration here (with the appropriate
# TODO FIXME: description)
# TODO FIXME: For example:
#   ##
#    # List of the configured cards.
#    #
#   my @cards = ();
#
#   ##
#    # Some additional parameter needed for the configuration.
#    #
#   my $additional_parameter = 1;

##
 # Read all XXpkgXX settings
 # @return true on success
 #
BEGIN { $TYPEINFO{Read} = ["function", "boolean"]; }
sub Read {

    # XXPkgXX read dialog caption
    my $caption = __("Initializing XXpkgXX Configuration");

    # TODO FIXME Set the right number of stages
    my $steps = 4;

    my $sl = 0.5;
    sleep($sl);

    # TODO FIXME Names of real stages
    # We do not set help text here, because it was set outside
    Progress->New( $caption, " ", $steps, [
	    # Progress stage 1/3
	    __("Read the database"),
	    # Progress stage 2/3
	    __("Read the previous settings"),
	    # Progress stage 3/3
	    __("Detect the devices")
	], [
	    # Progress step 1/3
	    __("Reading the database..."),
	    # Progress step 2/3
	    __("Reading the previous settings..."),
	    # Progress step 3/3
	    __("Detecting the devices..."),
	    # Progress finished
	    __("Finished")
	],
	""
    );

    # read database
    Progress->NextStage();
    # Error message
    if(0)
    {
	Report->Error(__("Cannot read the database1."));
    }
    sleep($sl);

    # read another database
    Progress->NextStep();
    # Error message
    if(0)
    {
	Report->Error(__("Cannot read the database2."));
    }
    sleep($sl);

    # read current settings
    Progress->NextStage();
    # Error message
    if(0)
    {
	Report->Error(Message->CannotReadCurrentSettings());
    }
    sleep($sl);

    # detect devices
    Progress->NextStage();
    # Error message
    if(0)
    {
	Report->Warning(__("Cannot detect devices."));
    }
    sleep($sl);

    # Progress finished
    Progress->NextStage();
    sleep($sl);

    $modified = 0;
    return Boolean(1);
}

##
 # Write all XXpkgXX settings
 # @return true on success
 #
BEGIN { $TYPEINFO{Write} = ["function", "boolean"]; }
sub Write {

    # XXPkgXX read dialog caption
    my $caption = __("Saving XXpkgXX Configuration");

    # TODO FIXME And set the right number of stages
    my $steps = 1;

    my $sl = 0.5;
    sleep($sl);

    # TODO FIXME Names of real stages
    # We do not set help text here, because it was set outside
    Progress->New($caption, " ", $steps, [
	    # Progress stage
	    __("Write the settings"),
	], [
	    # Progress step
	    __("Writing the settings..."),
	    # Progress finished
	    __("Finished")
	],
	""
    );

    # write settings
    Progress->NextStage();
    # Error message
    if(0)
    {
	Report->Error (__("Cannot write settings."));
    }
    sleep($sl);

    # Progress finished
    Progress->NextStage();
    sleep($sl);

    return Boolean(1);
}

##
 # Get all XXpkgXX settings from the first parameter
 # (For use by autoinstallation.)
 # @param settings The YCP structure to be imported.
 # @return boolean True on success
 #
BEGIN { $TYPEINFO{Import} = ["function", "boolean", [ "map", "any", "any" ] ]; }
sub Import {
    my %settings = %{$_[0]};
    # TODO FIXME: your code here (fill the above mentioned variables)...
    return Boolean(1);
}

##
 # Dump the XXpkgXX settings to a single map
 # (For use by autoinstallation.)
 # @return map Dumped settings (later acceptable by Import ())
 #
BEGIN { $TYPEINFO{Export}  =["function", [ "map", "any", "any" ] ]; }
sub Export {
    # TODO FIXME: your code here (return the above mentioned variables)...
    return {};
}

##
 # Create a textual summary and a list of unconfigured cards
 # @return summary of the current configuration
 #
BEGIN { $TYPEINFO{Summary} = ["function", [ "list", "string" ] ]; }
sub Summary {
    # TODO FIXME: your code here...
    # Configuration summary text for autoyast
    return (
	__("Configuration summary ...")
    );
}

##
 # Create an overview table with all configured cards
 # @return table items
 #
BEGIN { $TYPEINFO{Overview} = ["function", [ "list", "string" ] ]; }
sub Overview {
    # TODO FIXME: your code here...
    return ();
}

##
 # Return packages needed to be installed and removed during
 # Autoinstallation to insure module has all needed software
 # installed.
 # @return map with 2 lists.
 #
BEGIN { $TYPEINFO{AutoPackages} = ["function", ["map", "string", ["list", "string"]]]; }
sub AutoPackages {
    # TODO FIXME: your code here...
    my %ret = (
	"install" => (),
	"remove" => (),
    );
    return \%ret;
}

1;
# EOF
