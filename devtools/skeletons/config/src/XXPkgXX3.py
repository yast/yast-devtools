#!/usr/bin/env python

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

# File:		modules/XXPkgXX3.py
# Package:	Configuration of XXpkgXX
# Summary:	XXPkgXX settings, input and output functions
# Authors:	XXmaintainerXX <XXemailXX>
#
# $Id: XXPkgXX3.py 27914 2006-02-13 14:32:08Z locilka $
#
# Representation of the configuration of XXpkgXX.
# Input and output routines.


from time import sleep
from YCPDeclarations import YCPDeclare
import ycp
from ycp import Term, Symbol, Path
from ycp import y2internal, y2security, y2error, y2warning, y2milestone, y2debug 

##
 # Set textdomain
 #
import gettext
gettext.install("XXpkgXX")

ycp.import_module("Progress")
ycp.import_module("Report")
ycp.import_module("Summary")
ycp.import_module("Message")

##
 # Data was modified?
 #
modified = False

##
 #
proposal_valid = False

##
 # Write only, used during autoinstallation.
 # Don't run services it's all done at one place.
 #
write_only = False

##
 # Data was modified?
 # @return true if modified
 #
@YCPDeclare("boolean")
def Modified():
    global modified
    y2debug ("modified=%d" % (modified));
    return modified

##
 # Mark as modified, for Autoyast.
 #
@YCPDeclare("void", "boolean")
def SetModified(value):
    global modified
    modified = value

@YCPDeclare("boolean")
def ProposalValid():
    global proposal_valid
    return proposal_valid

@YCPDeclare("void", "boolean")
def SetProposalValid(value):
    global proposal_valid
    proposal_valid = value

@YCPDeclare("boolean")
def WriteOnly():
    global write_only
    return write_only

@YCPDeclare("void", "boolean")
def SetWriteOnly(value):
    global write_only
    write_only = value


# Settings: Define all variables needed for configuration of XXpkgXX
# TODO FIXME: Define all the variables necessary to hold
# TODO FIXME: the configuration here (with the appropriate
# TODO FIXME: description)
# TODO FIXME: For example:
#   ##
#    # List of the configured cards.
#    #
#   cards = []
#
#   ##
#    # Some additional parameter needed for the configuration.
#    #
#   additional_parameter = 1

##
 # Read all XXpkgXX settings
 # @return true on success
 #
@YCPDeclare("boolean")
def Read():
    global modified

    # XXPkgXX read dialog caption
    caption = _("Initializing XXpkgXX Configuration")

    # TODO FIXME Set the right number of stages
    steps = 4

    sl = 0.5
    sleep(sl)

    # TODO FIXME Names of real stages
    # We do not set help text here, because it was set outside
    ycp.Progress.New(caption, " ", steps, [
            # Progress stage 1/3
            _("Read the database"),
            # Progress stage 2/3
            _("Read the previous settings"),
            # Progress stage 3/3
            _("Detect the devices")
        ], [
            # Progress step 1/3
            _("Reading the database..."),
            # Progress step 2/3
            _("Reading the previous settings..."),
            # Progress step 3/3
            _("Detecting the devices..."),
            # Progress finished
            _("Finished")
        ],
        ""
    )

    # read database
    ycp.Progress.NextStage();
    # Error message
    if False:
        ycp.Report.Error(_("Cannot read the database1."))
    sleep(sl)

    # read another database
    ycp.Progress.NextStep()
    # Error message
    if False:
        ycp.Report.Error(_("Cannot read the database2."))
    sleep(sl)

    # read current settings
    ycp.Progress.NextStage()
    # Error message
    if False:
        ycp.Report.Error(ycp.Message.CannotReadCurrentSettings())
    sleep(sl)

    # detect devices
    ycp.Progress.NextStage()
    # Error message
    if False:
        ycp.Report.Warning(_("Cannot detect devices."))
    sleep(sl)

    # Progress finished
    ycp.Progress.NextStage()
    sleep(sl)

    modified = False

    return True

##
 # Write all XXpkgXX settings
 # @return true on success
 #
@YCPDeclare("boolean")
def Write():
    # XXPkgXX read dialog caption
    caption = _("Saving XXpkgXX Configuration")

    # TODO FIXME And set the right number of stages
    steps = 1

    sl = 0.5
    sleep(sl)

    # TODO FIXME Names of real stages
    # We do not set help text here, because it was set outside
    ycp.Progress.New(caption, " ", steps, [
            # Progress stage
            _("Write the settings"),
        ], [
            # Progress step
            _("Writing the settings..."),
            # Progress finished
            _("Finished")
        ],
        ""
    )

    # write settings
    ycp.Progress.NextStage()
    # Error message
    if False:
        ycp.Report.Error (_("Cannot write settings."))
    sleep(sl)

    # Progress finished
    ycp.Progress.NextStage()
    sleep(sl)

    return True

##
 # Get all XXpkgXX settings from the first parameter
 # (For use by autoinstallation.)
 # @param settings The YCP structure to be imported.
 # @return boolean True on success
 #
@YCPDeclare("boolean", "map")
def Import(map_settings):
    # TODO FIXME: your code here (fill the above mentioned variables)...
    return True

##
 # Dump the XXpkgXX settings to a single map
 # (For use by autoinstallation.)
 # @return map Dumped settings (later acceptable by Import ())
 #
@YCPDeclare("map")
def Export():
    # TODO FIXME: your code here (return the above mentioned variables)...
    return {}

##
 # Create a textual summary and a list of unconfigured cards
 # @return summary of the current configuration
 #
@YCPDeclare("list")
def Summary():
    # TODO FIXME: your code here...
    # Configuration summary text for autoyast
    return [ _("Configuration summary ...") ]

##
 # Create an overview table with all configured cards
 # @return table items
 #
@YCPDeclare("list")
def Overview():
    # TODO FIXME: your code here...
    return []

##
 # Return packages needed to be installed and removed during
 # Autoinstallation to insure module has all needed software
 # installed.
 # @return map with 2 lists.
 #
@YCPDeclare("map")
def AutoPackages():
    # TODO FIXME: your code here...
    return {
        "install" : [],
        "remove" : []
    }

# EOF
