/* XXPkgXXAgent.cc
 *
 * ------------------------------------------------------------------------------
 * Copyright (c) 2006 Novell, Inc. All Rights Reserved.
 * 
 * 
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of version 2 of the GNU General Public License as published by the
 * Free Software Foundation.
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along with
 * this program; if not, contact Novell, Inc.
 *
 * To contact Novell about this file by physical or electronic mail, you may find
 * current contact information at www.novell.com.
 * ------------------------------------------------------------------------------
 *
 * An agent for reading the XXpkgXX configuration file.
 *
 * Authors: XXmaintainerXX <XXemailXX>
 *
 * $Id$
 */

#include "XXPkgXXAgent.h"

/**
 * Constructor
 */
XXPkgXXAgent::XXPkgXXAgent() : SCRAgent()
{
}

/**
 * Destructor
 */
XXPkgXXAgent::~XXPkgXXAgent()
{
}

/**
 * Dir
 */
YCPList XXPkgXXAgent::Dir(const YCPPath& path)
{
    y2error("Wrong path '%s' in Read().", path->toString().c_str());
    return YCPNull();
}

/**
 * Read
 */
YCPValue XXPkgXXAgent::Read(const YCPPath &path, const YCPValue& arg, const YCPValue& opt)
{
    y2error("Wrong path '%s' in Read().", path->toString().c_str());
    return YCPNull();
}

/**
 * Write
 */
YCPBoolean XXPkgXXAgent::Write(const YCPPath &path, const YCPValue& value,
    const YCPValue& arg)
{
    y2error("Wrong path '%s' in Write().", path->toString().c_str());
    return YCPBoolean(false);
}

/**
 * Execute
 */
YCPValue XXPkgXXAgent::Execute(const YCPPath &path,
    const YCPValue& value , const YCPValue& arg)
{
    y2error("Wrong path '%s' in Execute().", path->toString().c_str());
    return YCPNull();
}

/**
 * otherCommand
 */
YCPValue XXPkgXXAgent::otherCommand(const YCPTerm& term)
{
    string sym = term->name();

    if (sym == "XXPkgXXAgent") {
        /* Your initialization */
        return YCPVoid();
    }

    return YCPVoid();
}
