#/* ------------------------------------------------------------------------------
# * Copyright (c) 2006 Novell, Inc. All Rights Reserved.
# *
# *
# * This program is free software; you can redistribute it and/or modify it under
# * the terms of version 2 of the GNU General Public License as published by the
# * Free Software Foundation.
# *
# * This program is distributed in the hope that it will be useful, but WITHOUT
# * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
# *
# * You should have received a copy of the GNU General Public License along with
# * this program; if not, contact Novell, Inc.
# *
# * To contact Novell about this file by physical or electronic mail, you may find
# * current contact information at www.novell.com.
# * ------------------------------------------------------------------------------
# */
#
#/**
# * File:        include/XXpkgXX/wizards.ycp
# * Package:        Configuration of XXpkgXX
# * Summary:        Wizards definitions
# * Authors:        XXmaintainerXX <XXemailXX>
# *
# * $Id: wizards.ycp 27914 2006-02-13 14:32:08Z locilka $
# */

import ycp
from ycp import Symbol, Path, Term

ycp.import_module("Sequencer2")
ycp.import_module("Wizard")
ycp.import_module("UI")

import complex
import dialogs

##
 # Set textdomain
 #
import gettext
gettext.install("XXpkgXX")


#/**
# * Add a configuration of XXpkgXX
# * @return sequence result
# */
def AddSequence():
    # FIXME: adapt to your needs
    aliases = {
        "config1"        : dialogs.Configure1Dialog,
        "config2"        : dialogs.Configure2Dialog,
    }

    # FIXME: adapt to your needs
    sequence = {
        "ws_start" : "config1",
        "config1" : {
            Symbol("abort") : Symbol("abort"),
            Symbol("next") : "config2"
        },
        "config2" : {
            Symbol("abort") : Symbol("abort"),
            Symbol("next") : Symbol("next")
        }
    }

    return ycp.Sequencer2.Run(aliases, sequence);

#/**
# * Main workflow of the XXpkgXX configuration
# * @return sequence result
# */
def MainSequence():
    # FIXME: adapt to your needs
    aliases = {
        "summary"  :   complex.SummaryDialog,
        "overview" :   complex.OverviewDialog,
        "configure" : [AddSequence, True ],
        "add" : [AddSequence, True ],
        "edit" : [AddSequence, True ]
    }

    # FIXME: adapt to your needs
    sequence = {
        "ws_start" : "summary",
        "summary" : {
            Symbol("abort")        : Symbol("abort"),
            Symbol("next")        : Symbol("next"),
            Symbol("overview")        : "overview",
            Symbol("configure")        : "configure",
            Symbol("other")        : "configure",
        },
        "overview" : {
            Symbol("abort")        : Symbol("abort"),
            Symbol("next")        : Symbol("next"),
            Symbol("add")        : "add",
            Symbol("edit")        : "edit",
        },
        "configure" : {
            Symbol("abort")        : Symbol("abort"),
            Symbol("next")        : "summary",
        },
        "add" : {
            Symbol("abort")        : Symbol("abort"),
            Symbol("next")        : "overview",
        },
        "edit" : {
            Symbol("abort")        : Symbol("abort"),
            Symbol("next")        : "overview",
        }
    }

    ret = ycp.Sequencer2.Run(aliases, sequence);

    return ret

#/**
# * Whole configuration of XXpkgXX
# * @return sequence result
# */
def XXPkgXXSequence():
    aliases = {
        "read" : [complex.ReadDialog, True ],
        "main" :  MainSequence,
        "write" : [complex.WriteDialog, True ]
    }

    sequence = {
        "ws_start" : "read",
        "read" : {
            Symbol("abort") : Symbol("abort"),
            Symbol("next") : "main"
        },
        "main" : {
            Symbol("abort") : Symbol("abort"),
            Symbol("next") : "write"
        },
        "write" : {
            Symbol("abort") : Symbol("abort"),
            Symbol("next") : Symbol("next")
        }
    }

    ycp.Wizard.CreateDialog()

    ret = ycp.Sequencer2.Run(aliases, sequence)

    ycp.UI.CloseDialog()
    return ret

#/**
# * Whole configuration of XXpkgXX but without reading and writing.
# * For use with autoinstallation.
# * @return sequence result
# */
def XXPkgXXAutoSequence():
    # Initialization dialog caption
    caption = _("XXPkgXX Configuration");
    # Initialization dialog contents
    contents = Term("Label", _("Initializing..."));

    ycp.Wizard.CreateDialog()
    ycp.Wizard.SetContentsButtons(caption, contents, "",
            ycp.Label.BackButton(), ycp.Label.NextButton())

    ret = MainSequence()

    ycp.UI.CloseDialog()
    return ret

