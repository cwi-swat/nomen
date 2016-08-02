module nomen::lang::Resolve

import nomen::lang::Nomen;
import nomen::lang::Selectors;
import nomen::lang::Declare;
import nomen::lang::Selectors;
import ParseTree;
import nomen::lang::Desugar;
import util::Maybe;
import Message;
import Set;
import String;
import IO;
import analysis::graphs::Graph;

/*
 * TODO: add loc scope  before loc use
 * do all error message based on refs, not env
 * scope is module scope or body scope (method/closure)
 * this eliminates most if-then-elses
 * NB: to delay error message creation, make sure that defs refer to themselves
 * otherwise unused var and shadowing errors cannot be detected.
 */


/*
What are our reference rels?

methodDecl ->* inherited
method call ->* all defs transitively imported
extends -> class decl
new Class -> class decl
qualifed class Decl -> classDecl + to itself
class Decl -> to itself
variable decl -> to itself
formal param -> to itself
closure param -> to itself
x = e ->  vardecls of x in scope
x -> -> vardecls of x in scope

*/

alias Refs = rel[Scope scope, loc use, loc def, str label];

bool isBeforeOrAt(loc x, loc y) = x.path == y.path && x.offset <= y.offset;
bool contains(loc x, loc y) 
  = x.path == y.path  
  && x.offset <= y.offset && x.length >= y.length + (y.offset - x.offset);


Refs resolveModule(start[Module] m, Env env) = resolveModule(m.top, env);

Refs resolveModule(Module m, Env env) {
  Refs refs = {};

  for (Decl decl <- m.decls) {
    switch (decl) {
    case (Decl)`import <MId i>`:
      refs += resolveImport(moduleScope(m), i, env);
  
    case (Decl)`class <SId c>: <CId d> <Member* ms>`:
      refs += resolveClass(decl@\loc, (CId)`<SId c>`[@\loc=c@\loc], env)
            + resolveClass(decl@\loc, d, env)
            + resolveMembers(decl@\loc, ms, env);

    case (Decl)`class <SId c> <Member* ms>`:
      refs += resolveClass(decl@\loc, (CId)`<SId c>`[@\loc=c@\loc], env)
            + resolveMembers(decl@\loc, ms, env);
    }
  }
  
  return refs;
}


Refs resolveImport(loc scope, MId mid, Env env)
  = {<scope, mid@\loc, d, "<mid>"> | 
//       <scope, \import("<mid>"), _> <- env,
       <_, \module("<mid>"), loc d> <- env };
  //+ {<scope, mid@\loc, mid@\loc, "<mid>">}; // self


Refs resolveClass(loc scope, x:(CId)`<MId mid>/<SId cls>`, Env env) 
  = { <scope, x@\loc, d, "<mid>/<cls>"> 
     | <Scope moduleScope, \import("<mid>"), _> <- env, contains(moduleScope, scope),
       <Scope importedScope, \module("<mid>"), _> <- env,
       <Scope importedClassScope, class("<cls>"), loc d> <- env,
          contains(importedScope, importedClassScope) };
   

Refs resolveClass(Scope scope, x:(CId)`<SId cls>`, Env env) {
  if (<Scope classScope, class("<x>"), loc d> <- env,
      <Scope moduleScope, \module(str m), _> <- env,
       contains(moduleScope, classScope),
       contains(moduleScope, scope)) {
       // todo: don't want to depend on label for semantics
       // need explicit representation of module name
    return {<scope, x@\loc, d, "<m>/<cls>">}; 
  }
  return 
    { <scope, x@\loc, d, "<imported>/<cls>"> 
     | <Scope moduleScope, \import(str imported), _> <- env, contains(moduleScope, scope),
       <Scope importedScope, \module(imported), _> <- env,  
       <Scope importedClassScope, class("<x>"), loc d> <- env, 
          contains(importedScope, importedClassScope) };
} 
  

Refs resolveMembers(loc scope, Member* ms, Env env)
  = {*resolveMember(scope, m, env) | m <- ms};
  
  
Refs resolveMember(loc scope, (Member)`def <DId d>(<{Id ","}* fs>): <Body b>`, Env env)
  = { <scope, d@\loc, inhMethod, "<super>/<d>/<a>"> | 
        <scope, \extend(str super), _> <- env, /*bprintln("Found super: <super>"),*/
        <Scope superScope, class("<super>"), _> <- env, /* bprintln("In scope: <superScope>"), */
        <superScope, method("<d>", a), loc inhMethod> <- env /*,bprintln("**** found decl: <inhMethod>") */} // todo: should be transitive
        
  + { *resolveVar(b@\loc, f, env) | f <- fs } + resolveBody(b@\loc, b, env)
  when a := arity(fs);

Refs resolveBody(Scope scope, (Body)`;`, Env env) = {};

Refs resolveBody(Scope scope, b:(Body)`<Stm* stms> <Stm stm>`, Env env) 
  = { *resolveStm(scope, s, env) | s <- stms } + resolveStm(scope, stm, env); 
  
Refs resolveStm(Scope scope, Stm stm, Env env) {
  Refs refs = {};
  
  top-down-break visit (stm) {
    case (Stm)`var <Id x> = <Expr e>;`:  {
      refs += resolveVar(scope, x, env) + resolveExpr(scope, e, env);
    }
    case Body b:
      refs += resolveBody(b@\loc, b, env);
    case Expr e:
      refs += resolveExpr(scope, e, env);
  }
  
  return refs;
}

Refs resolveExpr(Scope scope, Expr e, Env env) {
  Refs refs = {};
  
  Expr resolveCall(Expr e) {
    refs += resolveCall(scope, e, env);
    return e;
  }
  
  top-down-break visit (e) {
    case (Expr)`(<{Id ","}* fs>) { <Body b> }`: 
      refs += { *resolveVar(b@\loc, f, env) | f <- fs }
           + resolveBody(b@\loc, b, env);
    
    case (Expr)`<Id x>`: 
      refs += resolveVar(scope, x, env);

    case (Expr)`<Id x> = <Expr e>`: 
      refs += resolveVar(scope, x, env) + resolveExpr(scope, e, env);
    
    case (Expr)`new <CId c>(<{Expr ","}* args>)`:
      refs += resolveClass(scope, c, env)
           + {*resolveExpr(scope, a, env) | a <- args}; 
    
    case Expr exp => resolveCall(exp)
      when isMethodCall(e)
  }
  
  return refs;
}

Refs resolveVar(loc scope, Id x, Env env) 
  = {<scope, x@\loc, d, "<x>"> | <loc aScope, var("<x>"), loc d> <- env , contains(aScope, scope) };

Refs resolveCall(Scope scope, Expr call, Env env) 
  = { <scope, u@\loc, d, "<c>/<u>/<a>"> | // link to all definitions 
        <Scope classScope, method("<u>", a), loc d> <- env,
        <classScope, class(str c), _> <- env }
  + resolveExpr(scope, recv, env)
  + { *resolveExpr(scope, arg, env) | arg <- es }
  when
     <Expr recv, DId u, {Expr ","}* es> := destructure(call), 
     int a := arity(es);



  


