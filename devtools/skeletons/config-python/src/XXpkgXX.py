#!/usr/bin/env python

# ------------------------------------------------------------------------------
# Copyright (c) 2006 Novell, Inc. All Rights Reserved.
#
#
# This program is free software; you can redistribute it andor modify it under
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
#

#
# File:        clientsXXpkgXX.py
# Package:        Configuration of XXpkgXX
# Summary:        Main file
# Authors:        XXmaintainerXX <XXemailXX>
#
# $Id: XXpkgXX.ycp 27914 2006-02-13 14:32:08Z locilka $
#
# Main file for XXpkgXX configuration. Uses all other files.
#

import sys
import ycp
from ycp import Term, Symbol, Path
from ycp import y2internal, y2security, y2error, y2warning, y2milestone, y2debug 

import gettext
gettext.install("XXpkgXX")

ycp.init_ui("qt")

##
# <h3>Configuration of XXpkgXX</h3>
#


# The main () 
y2milestone("----------------------------------------")
y2milestone("XXPkgXX module started")

ycp.import_module("Progress")
ycp.import_module("Report")
ycp.import_module("Summary")
ycp.import_module("XXPkgXX")

ycp.import_module("CommandLine")

#TODO
import wizards

cmdline_description = {
    "id"         : "XXpkgXX",
    # Command line help text for the XXXpkgXX module
    "help"        : _("Configuration of XXpkgXX"),
    "guihandler"        : wizards.XXPkgXXSequence,
    "initialize"        : ycp.XXPkgXX.Read,
    "finish"            : ycp.XXPkgXX.Write,
    "actions"           : {
        # FIXME TODO: fill the functionality description here
    },
    "options"                : {
        # FIXME TODO: fill the option descriptions here
    },
    "mappings"                : {
        # FIXME TODO: fill the mappings of actions and options here
    }
}

# TODO
# is this proposal or not?
#propose = False
#args = ycp.WFM.Args()
#if len(args) > 0):
#    if ycp.isPath(ycp.WFM.Args(0)) and ycp.WFM.Args(0) == Path(".propose"):
#        y2milestone("Using PROPOSE mode");
#        propose = True;

# main ui function
ret = None

#if propose: ret = XXPkgXXAutoSequence()
#else: ret = ycp.CommandLine.Run(cmdline_description)
#y2debug("ret=%d" % (ret))
ycp.CommandLine.Run(cmdline_description)

# Finish
y2milestone("XXPkgXX module finished");
y2milestone("----------------------------------------");

sys.exit(ret)
