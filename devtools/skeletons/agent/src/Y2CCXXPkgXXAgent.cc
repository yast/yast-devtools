

/*
 *  Author: Arvin Schnell <arvin@suse.de>
 */


#include <scr/Y2AgentComponent.h>
#include <scr/Y2CCAgentComponent.h>
#include <scr/SCRInterpreter.h>

#include "XXPkgXXAgent.h"


typedef Y2AgentComp <XXAgent> Y2XXAgentComp;

Y2CCAgentComp <Y2XXAgentComp> g_y2ccag_xxagent ("ag_xxagent");

