

import cpp

from MacroInvocation call
where call.getMacroName().regexpMatch("ntoh[s|l|ll]")
select call.getExpr()