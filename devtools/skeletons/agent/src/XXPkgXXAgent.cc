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
YCPValue XXPkgXXAgent::Dir(const YCPPath& path)
{
    y2error("Wrong path '%s' in Read().", path->toString().c_str());
    return YCPVoid();
}

/**
 * Read
 */
YCPValue XXPkgXXAgent::Read(const YCPPath &path, const YCPValue& arg)
{
    y2error("Wrong path '%s' in Read().", path->toString().c_str());
    return YCPVoid();
}

/**
 * Write
 */
YCPValue XXPkgXXAgent::Write(const YCPPath &path, const YCPValue& value,
			     const YCPValue& arg)
{
    y2error("Wrong path '%s' in Write().", path->toString().c_str());
    return YCPVoid();
}

/**
 * otherCommand
 */
YCPValue XXPkgXXAgent::otherCommand(const YCPTerm& term)
{
    string sym = term->symbol()->symbol();

    if (sym == "XXPkgXXAgent") {
        /* Your initialization */
        return YCPVoid();
    }

    return YCPNull();
}
