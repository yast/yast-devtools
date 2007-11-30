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
#
#
#/**
# * File:        include/XXpkgXX/complex.ycp
# * Package:        Configuration of XXpkgXX
# * Summary:        Dialogs definitions
# * Authors:        XXmaintainerXX <XXemailXX>
# *
# * $Id: complex.ycp 41350 2007-10-10 16:59:00Z dfiser $
# */

import ycp
from ycp import Symbol, Term, Path
from YCPDeclarations import YCPDeclare

##
 # Set textdomain
 #
import gettext
gettext.install("XXpkgXX")

ycp.import_module("Label")
ycp.import_module("Popup")
ycp.import_module("Wizard")
ycp.import_module("Wizard_hw")
ycp.import_module("Confirm")
ycp.import_module("UI")
ycp.import_module("XXPkgXX")

from helps import HELPS

#include "XXpkgXX/helps.ycp";

#/**
# * Return a modification status
# * @return true if data was modified
# */
def Modified():
    return ycp.XXPkgXX.Modified()

def ReallyAbort():
    return not ycp.XXPkgXX.Modified() or ycp.Popup.ReallyAbort(True)

def PollAbort():
    return ycp.UI.PollInput() == Symbol("abort")

#/**
# * Read settings dialog
# * @return `abort if aborted and `next otherwise
# */
@YCPDeclare("symbol")
def ReadDialog():
    ycp.Wizard.RestoreHelp(HELPS["read"])
    #// XXPkgXX::SetAbortFunction(PollAbort);
    if not ycp.Confirm.MustBeRoot(): return Symbol("abort")

    ret = ycp.XXPkgXX.Read()
    if ret:
        return Symbol("next")
    else:
        return Symbol("abort")

#/**
# * Write settings dialog
# * @return `abort if aborted and `next otherwise
# */
@YCPDeclare("symbol")
def WriteDialog():
    ycp.Wizard.RestoreHelp(HELPS["write"])
    #// XXPkgXX::SetAbortFunction(PollAbort);

    ret = ycp.XXPkgXX.Write()
    if ret:
        return Symbol("next")
    else:
        return Symbol("abort")

#/**
# * Summary dialog
# * @return dialog result
# */
@YCPDeclare("symbol")
def SummaryDialog():
    #/* XXPkgXX summary dialog caption */
    caption = _("XXPkgXX Configuration");

    #/* FIXME */
    summary = ycp.XXPkgXX.Summary();
    unconfigured = summary[1];
    configured = summary[0];

    #/* Frame label */
    contents = ycp.Wizard_hw.DetectedContent(_("XXPkgXX to Configure"),
            unconfigured, False, configured);

    ycp.Wizard.SetContentsButtons(caption, contents, HELPS["summary"],
            ycp.Label.BackButton(), ycp.Label.FinishButton())

    ret = None
    while True:
        ret = ycp.UI.UserInput()

        #/* abort? */
        if ret == Symbol("abort") or ret == Symbol("cancel") or ret == Symbol("back"):
            if ReallyAbort(): break
            else: continue

        #/* overview dialog */
        elif ret == Symbol("edit_button"):
            ret = Symbol("overview")
            break

        #/* configure the selected device */
        elif ret == Symbol("configure_button"):
            #// TODO FIXME: check for change of the configuration
            selected = ycp.UI.QueryWidget(Term("id", Symbol("detected_selbox")), Symbol("CurrentItem"))
            if selected == Symbol("other"):
                ret = Symbol("other")
            else:
                ret = Symbol("configure")
            break

        elif ret == Symbol("next"):
            break
        else:
            y2error("unexpected retcode: %s" % (ret))
            continue

    return ret

#/**
# * Overview dialog
# * @return dialog result
# */
@YCPDeclare("symbol")
def OverviewDialog():
    # XXPkgXX overview dialog caption
    caption = _("XXPkgXX Overview")

    overview = ycp.XXPkgXX.Overview()

    #/* FIXME table header */
    contents = ycp.Wizard_hw.ConfiguredContent(
        #/* Table header */
        Term("header", _("Number"), _("XXPkgXX")),
        overview, None, None, None, None)

    contents = ycp.Wizard_hw.SpacingAround(contents, 1.5, 1.5, 1.0, 1.0);

    ycp.Wizard.SetContentsButtons(caption, contents, HELPS["overview"],
            ycp.Label.BackButton(), ycp.Label.FinishButton())

    ret = None

    while True:
        ret = ycp.UI.UserInput()

        #/* abort? */
        if ret == Symbol("abort") or ret == Symbol("cancel"):
            if ReallyAbort(): break
            else: continue

        #/* add */
        elif ret == Symbol("add_button"):
            #/* FIXME */
            ret = Symbol("add")
            break

        #/* edit */
        elif ret == Symbol("edit_button"):
            #/* FIXME */
            ret = Symbol("edit")
            break

        #/* delete */
        elif ret == Symbol("delete_button"):
            #/* FIXME */
            continue

        elif ret == Symbol("next") or ret == Symbol("back"):
            break

        else:
            y2error("unexpected retcode: %s", ret);
            continue

    return ret

