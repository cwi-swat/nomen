module nomen::lang::Check

import nomen::lang::Nomen;
import nomen::lang::Selectors;
import nomen::lang::Resolve;
import IO;
import ParseTree;
import nomen::lang::Desugar;
import util::Maybe;
import Message;
import Set;
import String;
import analysis::graphs::Graph;


/*
 * Testing
 */
 
tuple[Refs, set[Message]] checkModules(Module* ms) {
  map[MId, Module] modules = ( m.name: desugar(m) | Module m <- ms );
  MId kernel = [MId]KERNEL;
  if (just(start[Module] k) := load(KERNEL, [])) {
    modules[kernel] = k.top;
  }
  else {
    return <{}, {error("Could not load kernel: <KERNEL>", ms@\loc)}>;
  } 
  importedBy = { <m2, m1.name> | m1 <-ms, /(Decl)`import <MId m2>` := m1 }
     + { <kernel, m1.name> | m1 <- ms };
     
  if (<MId m0, m0> <- importedBy+) {
    // todo: move to check phase
    return <{}, {error("Cyclic import", m0@\loc)}>;
  }
  
  map[MId, Env] envs = ();
  ord = order(importedBy);
  for (mid <- ord, mid in modules) {
    curEnv = declareModule(modules[mid], envs);
    envs[mid] = curEnv; 
  }
  if (ord == []) {
    return {};
  }
  main = ord[-1];
  //println("Resolving for <main>");
  refs = resolveModule(modules[main], envs[main]);
  //println("Checking <main>");
  msgs = checkModule(modules[main], refs);
  //println("Messages:");
  //iprintln(msgs);
  return <refs, msgs>;
}


set[loc] lookup(loc scope, loc x, Refs refs) 
  = { d | <loc s, x, loc d, _> <- refs, contains(s, scope), isBeforeOrAt(d, x)};

set[loc] lookupClass(loc scope, loc x, Refs refs) 
  = { d | <loc s, x, loc d, _> <- refs, contains(s, scope)};

bool isFirst(loc x, set[loc] ds) {
  <current, ds> = takeOneFrom(ds);
  for (d <- ds) {
    if (d.offset <= current.offset) {
      current = d;
    }
  }
  return current == x;
}

bool redeclared(loc scope, loc x, Refs refs) {
    ds = lookup(scope, x, refs);
    ret = x in ds && size(ds) > 1 && !isFirst(x, ds);
    //if (ret) println("Redeclared: <x> --\> <ret>");
    return ret;
}  

set[Message] checkVar(loc scope, Id x, Refs refs) 
  = {error("Undeclared variable", x@\loc)}
  when 
    lookup(scope, x@\loc, refs) == {};

set[Message] checkVar(loc scope, Id x, Refs refs) 
  = {error("Shadowing", x@\loc)}
  when 
    redeclared(scope, x@\loc, refs);

default set[Message] checkVar(loc scope, Id c, Refs refs) = {};
  
  
set[Message] checkClass(loc scope, CId c, Refs refs)
  = {error("No such class", c@\loc)}
  when 
    lookupClass(scope, c@\loc, refs) == {};

set[Message] checkClass(loc scope, CId c, Refs refs)
  = {error("Redeclared class", c@\loc)}
  when 
    redeclared(scope, c@\loc, refs);

default set[Message] checkClass(loc scope, CId c, Refs refs) = {};

set[Message] checkCall(loc scope, Expr call, Refs refs) 
  = checkExpr(scope, recv, refs)
  + { *checkExpr(scope, arg, refs) | arg <- es }
  when
     (<Expr recv, DId u, {Expr ","}* es> := destructure(call));

  
set[Message] checkImport(loc scope, MId mid, Refs refs)
  = {error("No such module", mid@\loc)}
  when 
    l := mid@\loc, 
    !(<scope, l,  _, _> <- refs);

//set[Message]checkImport(loc scope, MId mid, Refs refs)
//  = {warning("Duplicate import", mid@\loc)}
//  when 
//    redeclared(scope, mid@\loc, refs); 

default set[Message] checkImport(loc scope, MId mid, Refs refs) = {};

set[Message] checkExtends(loc scope, CId x, CId y, Refs refs) 
  = { error("Patched class cannot extend", y@\loc) | x is qualified }
  + { error("Class cannot extend itself", x@\loc) |
      <scope, xl, loc d, _> <- refs,
      <scope, yl, d, _> <- refs }
  when xl := x@\loc, yl := y@\loc;


set[Message] checkModule(start[Module] m, Refs refs) 
  = checkModule(m.top, refs);

set[Message] checkModule(Module m, Refs refs) {
  set[Message] msgs = {};

  for (Decl decl <- m.decls) {
    switch (decl) {
    case (Decl)`import <MId i>`:
      msgs += checkImport(moduleScope(m), i, refs);
  
    case (Decl)`class <CId c>: <CId d> <Member* ms>`:
      msgs += checkClass(decl@\loc, c, refs)
            + checkClass(decl@\loc, d, refs)
            + checkExtends(decl@\loc, c, d, refs)
            + checkMembers(decl@\loc, ms, refs);

    case (Decl)`class <CId c> <Member* ms>`:
      msgs += checkClass(decl@\loc, c, refs)
            + checkMembers(decl@\loc, ms, refs);
    }
  }
  
  return msgs;
}

set[Message] checkMembers(loc scope, Member* ms, Refs refs)
  = {*checkMember(scope, m, refs) | m <- ms};
  
  
//// TODO: check for override
//set[Message] checkMember(loc scope, (Member)`def <DId d>(<{Id ","}* fs>): <Body b>`, Refs refs)
//  = { *checkVar(b@\loc, f, refs) | f <- fs } + checkBody(b, refs) 
//  + { error("Override needs redef", d@\loc)  | d1 := d@\loc, <scope, d1, loc d2, _> <- refs, 
//    bprintln("######### override"), d1 != d2 };
    

//set[Message] checkMember(loc scope, (Member)`redef <DId d>(<{Id ","}* fs>): <Body b>`, Refs refs)
//  = { *checkVar(b@\loc, f, refs) | f <- fs } + checkBody(b, refs) 
//  + { error("Method does not override", d@\loc)  | d1 := d@\loc, 
//        !any(<scope, d1, loc d2, _> <- refs, d1 != d2) }; 

default set[Message] checkMember(loc scope, Member m, Refs refs) = {};

set[Message] checkBody((Body)`;`, Refs refs) = {};

set[Message] checkBody(b:(Body)`<Stm* stms> <Stm stm>`, Refs refs) 
  = { *checkStm(b@\loc, s, refs) | s <- stms } + checkStm(b@\loc, stm, refs); 
  
set[Message] checkStm(loc scope, Stm stm, Refs refs) {
  set[Message] msgs = {};
  
  top-down-break visit (stm) {
    case (Stm)`var <Id x> = <Expr e>;`:  
      msgs += checkVar(scope, x, refs) + checkExpr(scope, e, refs);
    case Body b:
      msgs += checkBody(b, refs);
    case Expr e:
      msgs += checkExpr(scope, e, refs);
  }
  
  return msgs;
}

set[Message] checkExpr(loc scope, Expr e, Refs refs) {
  set[Message] msgs = {};
  
  Expr checkCall(Expr e) {
    msgs += checkCall(scope, e, refs);
    return e;
  }
  
  top-down-break visit (e) {
    case (Expr)`(<{Id ","}* fs>) { <Body b> }`: 
      msgs += { *checkVar(b@\loc, f, refs) | f <- fs }
           + checkBody(b, refs);
    
    case (Expr)`<Id x>`: 
      msgs += checkVar(scope, x, refs);

    case (Expr)`<Id x> = <Expr e2>`: 
      msgs += checkVar(scope, x, refs) + checkExpr(scope, e2, refs);
    
    case (Expr)`new <CId c>(<{Expr ","}* args>)`:
      msgs += checkClass(scope, c, refs)
           + { *checkExpr(scope, a, refs) | a <- args}; 
    
    case Expr exp => checkCall(exp)
      when isMethodCall(e)
  }
 
 
  return msgs;
}
