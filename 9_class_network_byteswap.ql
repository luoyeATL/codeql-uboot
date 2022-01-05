
import cpp

class GetNtoh extends Expr {
    GetNtoh(){
        exists(MacroInvocation call|  call.getMacroName().regexpMatch("ntoh[s|l|ll]") and this = call.getExpr())
    }
}

from GetNtoh f
select f