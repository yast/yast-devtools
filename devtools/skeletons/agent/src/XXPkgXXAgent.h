/* XXPkgXXAgent.h
 *
 * XXPkgXX agent implementation
 *
 * Authors: XXmaintainerXX <XXemailXX>
 *
 * $Id$
 */

#ifndef _XXPkgXXAgent_h
#define _XXPkgXXAgent_h

#include <Y2.h>
#include <scr/SCRAgent.h>
#include <scr/SCRInterpreter.h>

/**
 * @short An interface class between YaST2 and XXPkgXX Agent
 */
class XXPkgXXAgent : public SCRAgent
{
private:
    /**
     * Agent private variables
     */

public:
    /**
     * Default constructor.
     */
    XXPkgXXAgent();

    /**
     * Destructor.
     */
    virtual ~XXPkgXXAgent();

    /**
     * Provides SCR Read ().
     * @param path Path that should be read.
     * @param arg Additional parameter.
     */
    virtual YCPValue Read(const YCPPath &path,
			  const YCPValue& arg = YCPNull());

    /**
     * Provides SCR Write ().
     */
    virtual YCPValue Write(const YCPPath &path,
			   const YCPValue& value,
			   const YCPValue& arg = YCPNull());

    /**
     * Provides SCR Execute ().
     */
    virtual YCPValue Execute(const YCPPath &path,
			     const YCPValue& value = YCPNull(),
			     const YCPValue& arg = YCPNull());

    /**
     * Provides SCR Dir ().
     */
    virtual YCPValue Dir(const YCPPath& path);

    /**
     * Used for mounting the agent.
     */
    virtual YCPValue otherCommand(const YCPTerm& term);
};

#endif /* _XXPkgXXAgent_h */
