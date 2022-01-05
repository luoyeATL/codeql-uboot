/**
 * @name itoh
 * @kind path-problem
 * @id codeql-uboot/taint-tracking
 */

import cpp
import semmle.code.cpp.dataflow.TaintTracking
import DataFlow::PathGraph

class NetworkByteSwap extends Expr{
    NetworkByteSwap(){
        exists(MacroInvocation c|  c.getMacroName().regexpMatch("ntoh[s|l|ll]") and this = c.getExpr())
    }
}

class Config extends TaintTracking::Configuration{
    Config(){this="NetworkToMemFuncLength"}
    override predicate isSource(DataFlow::Node source){
        source.asExpr() instanceof NetworkByteSwap
    }

    override predicate isSink(DataFlow::Node sink){
        exists (FunctionCall c| 
            sink.asExpr() = c.getArgument(2) and
            c.getTarget().getName() = "memcpy"
        ) 
    }
}

from Config cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink, source, sink, "Network byte swap flows to memcpy"