/* XXPkgXXAgent.cc
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
