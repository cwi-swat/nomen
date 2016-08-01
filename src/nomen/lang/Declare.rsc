module nomen::lang::Declare

import nomen::lang::Nomen;
import nomen::lang::Selectors;
import ParseTree;

alias Scope = loc;

// TODO: names are strings now, just because binary value IO
// does not work on concrete syntax values.
data Entity // todo: record module origin
  = \module(str name) // scope will be module
  | class(str name) // scope will be class
  | method(str name, int arity) // scope will be class scope
  | selector(str name, int arity) // scope will be body
  | var(str name) // scope will be body
  | \import(str name) // scope will be module
  | \extend(str name) // scope will be class
  ;

alias Env = rel[Scope scope, Entity entity, loc def];
  
public str KERNEL = "nomen/lang/Kernel"; 

loc moduleScope(start[Module] m) = moduleScope(m.top);
loc moduleScope(Module m) = m@\loc;
loc classScope(d:(Decl)`class <CId _> <Extends _> <Member* _>`) = d@\loc; 
loc classScope(d:(Decl)`class <CId _> <Member* _>`) = d@\loc; 
loc methodScope(Member m) = m@\loc;

bool isKernel(start[Module] m) = isKernel(m.top);
bool isKernel(Module m) = "<m.name>" == KERNEL;

Env declareModule(start[Module] m) = declareModule(m.top);

Env declareModule(Module m) {
  Env env = { <moduleScope(m), \import("<i>"), i@\loc> | (Decl)`import <MId i>` <- m.decls };
  env += { *declareClass(d) | Decl d <- m.decls, d is class }; 
  return env + {<moduleScope(m), \module("<m.name>"), m.name@\loc>};
}

Env declareClass(d:(Decl)`class <CId c> <Member* ms>`) 
  = {<classScope(d), class("<c>"), c@\loc>}
  + {<classScope(d), \extend("nomen/lang/Kernel/Obj"), c@\loc>} 
  + { *declareMethod(classScope(d), m) | m <- ms }; 

Env declareClass(d:(Decl)`class <CId c>: <CId x> <Member* ms>`) 
  = {<classScope(d), class("<c>"), c@\loc>}
  + {<classScope(d), \extend("<x>"), x@\loc>} // todo: qualification 
  + { *declareMethod(classScope(d), m) | m <- ms }; 


Env declareMethod(Scope scope, m:(Member)`def <DId d>(<{Id ","}* fs>): <Body b>`) 
  = {<scope, method("<d>", arity(fs)), d@\loc>}
  + declareFormals(methodScope(m), fs) 
  + declareBody(methodScope(m), b);

Env declareVar(Scope scope, Id x) 
  = {<scope, var("<x>"), x@\loc>};

Env declareFormals(Scope scope, {Id ","}* fs) 
  = { *declareVar(scope, f) | f <- fs };

Env declareBody(Scope scope, (Body)`;`) = {};

Env declareBody(Scope scope, (Body)`<Stm* stms> <Stm stm>`) 
  = { *declareStm(scope, s) | s <- stms } + declareStm(scope, stm);

Env declareStm(Scope scope, Stm stm) {
  Env env = {};
  
  top-down-break visit(stm) {
    case (Stm)`var <Id x> = <Expr e>;`:
      env += declareVar(scope, x) + declareExpr(scope, e);
    case (Stm)`for <Id x> in <Expr e> do <Body b> end`:
      env += declareVar(b@\loc, x) + declareBody(b@\loc, b);
    case Body b: 
      env += declareBody(b@\loc, b);
    case Expr e:
      env += declareExpr(scope, e);
  }
  
  return env;
}

Env declareExpr(Scope scope, Expr e) {
  Env env = {};
  
  Expr declareSelector(Expr e) {
    env += declareSelector(scope, e);
    return e;
  }
  
  top-down-break visit(e) {
    case (Expr)`(<{Id ","}* fs>){<Body b>}`: 
      env += declareFormals(b@\loc, fs) + declareBody(b@\loc, b);
    case Expr e => declareSelector(e)
      when isMethodCall(e)
  }
  
  return env;
}

Env  declareSelector(Scope scope, Expr call) 
  = {<scope, selector("<u>", arity(es)), u@\loc> }
  + { *declareExpr(scope, arg) | arg <- es }
  + declareExpr(scope, recv) 
when 
  <Expr recv, DId u, {Expr ","}* es> := destructure(call);

