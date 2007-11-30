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
# * File:        include/XXpkgXX/dialogs.ycp
# * Package:        Configuration of XXpkgXX
# * Summary:        Dialogs definitions
# * Authors:        XXmaintainerXX <XXemailXX>
# *
# * $Id: dialogs.ycp 27914 2006-02-13 14:32:08Z locilka $
# */

import ycp
from ycp import Symbol, Term, Path
from YCPDeclarations import YCPDeclare

ycp.import_module("Label")
ycp.import_module("Wizard")
ycp.import_module("UI")

##
 # Set textdomain
 #
import gettext
gettext.install("XXpkgXX")

from helps import HELPS
import complex

#/**
# * Configure1 dialog
# * @return dialog result
# */
@YCPDeclare("symbol")
def Configure1Dialog():
    #/* XXPkgXX configure1 dialog caption */
    caption = _("XXPkgXX Configuration");

    #/* XXPkgXX configure1 dialog contents */
    contents = Term("Label", _("First part of configuration of XXpkgXX"))

    ycp.Wizard.SetContentsButtons(caption, contents, HELPS["c1"],
            ycp.Label.BackButton(), ycp.Label.NextButton())

    ret = None
    while True:
        ret = ycp.UI.UserInput()

        #/* abort? */
        if ret == Symbol("abort") or ret == Symbol("cancel"):
            if complex.ReallyAbort(): break
            else: continue

        elif ret == Symbol("next") or ret == Symbol("back"):
            break
            
        else:
            y2error("unexpected retcode: %s", ret)
            continue

    return ret

#/**
# * Configure2 dialog
# * @return dialog result
# */
@YCPDeclare("symbol")
def Configure2Dialog():
    #/* XXPkgXX configure2 dialog caption */
    caption = _("XXPkgXX Configuration")

    #/* XXPkgXX configure2 dialog contents */
    contents = Term("Label", _("Second part of configuration of XXpkgXX"))

    ycp.Wizard.SetContentsButtons(caption, contents, HELPS["c2"],
            ycp.Label.BackButton(), ycp.Label.NextButton())

    ret = None
    while True:
        ret = ycp.UI.UserInput()

        #/* abort? */
        if ret == Symbol("abort") or ret == Symbol("cancel"):
            if complex.ReallyAbort(): break
            else: continue

        elif ret == Symbol("next") or ret == Symbol("back"):
            break

        else:
            y2error("unexpected retcode: %s", ret)
            continue

    return ret
