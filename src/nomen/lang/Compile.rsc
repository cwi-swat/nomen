module nomen::lang::Compile

import nomen::lang::Nomen;
import nomen::lang::Selectors;
import nomen::lang::Resolve;
import nomen::lang::Desugar;
import nomen::lang::Declare;
import List;
import IO;
import String;
import ParseTree;


str mid2java(str x) = replaceAll(x, "/", ".");
str cid2java(str x) = "$<replaceAll(x, "/", "$")>";

alias Classes = rel[str path, str class];



Refs _REFS = {};


//str compileModule(MId m, list[loc] searchPath, Log log = noLog) {
//  <msgs, mb> = load(m, searchPath = searchPath, log = log);
//  if (just(Built b) := mb) {
//    return compileModule(b.pt, b.env, b.refs, b.classes);
//  }
//  iprintln(msgs);
//  return "error";
//}

//tuple[set[Message], Maybe[Built]] load(MId m, Maybe[start[Module]] maybePt = nothing(), 
//                       list[loc] searchPath = [], bool clean = false, Log log = noLog) {

// presumes desugared
str compileModule(start[Module] pt, Env env, Refs refs, Classes classes) {
   Module m = pt.top;

   _REFS = refs; // todo: pass down refs.

   tuple[str, str] decomp((MId)`<SId x>`) = <"", "<x>">;
   tuple[str, str] decomp((MId)`<{PId "/"}+ p>/<SId x>`) = <mid2java("<p>"), "<x>">;
   
   <pkg, cls> = decomp(m.name); 
   name = "<m.name>";
   
   loc file = pt@\loc[extension="java"];
   
   src =  "<pkg == "" ? "" : "package <pkg>;"> 
          '@SuppressWarnings({\"unchecked\"})
          'public interface <cls>\<$O extends <cls>\<$O\>\><if (<_, \import(_), _> <- env) {> 
          '   extends <intercalate(", ", [ "<mid2java(i)>\<$O\>" | <_, \import(str i), _> <- env ])><}> {
          '  <for (selector(str d, int arity) <- env<1>) {>
          '  default $O <mangle(d)>(<intercalate(", ", [ "$O arg<i>" | i <- [0..arity] ])>) {
          '     return method_missing($str(\"<unquote("<d>")>\"), $array(<intercalate(", ", [ "arg<i>" | i <- [0..arity] ])>));
          '  }<}>
          '  
          '  <for (Decl d <- m.decls, d is class) {>
          '  <compileClass(d, m.name, refs, d@\loc)>
          '  <}>
          '  
          '  <for (/Expr e := m, isAnonNew(e)) {>
          '  <compileAnonClass(e, m.name, refs)>
          '  <}>
          '  
          '  <if (hasMain(m.decls)) {>
          '    interface $Self extends <cls>\<$Self\> { }
          '    <for (<str i, str c> <- classes) {>
          '    <i != name ? "@Override" : "">
          '    default $O <cid2java("<i>/<c>")>() {
          '      return ($O)new <cid2java("<i>/<c>")>();
          '    }
          '    <}> 
          '    <for (<str i, str c> <- classes) {>
          '    class <cid2java("<i>/<c>")> extends <mid2java(i)>.<c>\<$Self\> implements $Self { } 
          '    <}>
          '    static void main(String[] args) {
          '      Main\<$Self\> main = new Main\<$Self\>() {};
          '      main.main(main.$args(args));
	        '    }
	        '  <} else {>
	        '    <for (<name, str c> <- classes) {>
          '  $O <cid2java("<name>/<c>")>();
          '    <}>
	        '  <}>
          '}";
     
   return src;       
}

bool hasMain(Decl* ds)
  = (Decl d <- ds && d has name && d.name == (CId)`Main`
    && (Member)`def main(<Id _>): <Body _>` <- d.members);

bool isAnonNew((Expr)`new <CId _>(<{Expr ","}* _>) {<Member* ms>}`) = true;
default bool isAnonNew(Expr _) = false;

str compileClass((Decl)`class <CId c> <Member* ms>`, MId mid, Refs refs, Scope cScope, set[Id] captures = {}) 
  = compileClass((Decl)`class <CId c>: <CId d> <Member* ms>`, mid, refs, cScope, captures=captures)
  when CId d := [CId]"<KERNEL>/Obj";

str compileClass((Decl)`class <CId c>: <CId d> <Member* ms>`, MId mid, Refs refs, Scope cScope, set[Id] captures = {}) {
  flds = { x |  /(FId)`@<ID x>` := ms };
  
  super = "";
  l = d@\loc;
  if (<_, l, _, str s> <- refs) {
    super = s;
  }
  else {
    super = "<KERNEL>/Obj"; // sensible (?) default
  } 
  
  return "abstract class <c>\<$O extends <mid2java("<mid>")>\<$O\>\> extends <mid2java(super)>\<$O\> implements <mid2java("<mid>")>\<$O\> {
         '  <for (x <- flds) {>protected $O _<x>;
         '  <}>
         '  <for (Id x <- captures) {>public $O[] <x>;
         '  <}>
         '
         '  public <c>() { 
         '    super(); 
         '    <for (x <- flds) {>this._<x> = $nil();
         '    <}>
         '  }
         '  <for (m <- ms) {><compileMethod(mid, c, m, cScope)>
         '  <}>
         '}"; 
}

str compileAnonClass(e:(Expr)`new {<Member* ms>}`, MId mid, Refs refs)  
  = compileClass((Decl)`class <CId anon> <Member* ms>`, mid, refs, e@\loc, captures=captured(e, refs))
  when anon := [CId]anonymous(e@\loc);

str compileAnonClass(e:(Expr)`new <CId c>(<{Expr ","}* es>) {<Member* ms>}`, MId mid, Refs refs)  
  = compileClass((Decl)`class <CId anon>: <CId c> <Member* ms>`, mid, refs, e@\loc, captures=captured(e, refs))
  when anon := [CId]anonymous(e@\loc);
  

str compileMethod(MId mid, CId cls, (Member)`def <DId d>(<{Id ","}* fs>): <Body b>`, Scope cScope) {
  return "@Override
         'public $O <mangle(d)>(<intercalate(", ", [ "$O <f>" | f <- fs ])>) {
         '  $O $ret = $nil();
         '  <compileBody(b, cls, cScope)>
         '  return $ret;
         '}";
}


str compileBody((Body)`;`, CId cls, Scope cScope) = "";

str compileBody((Body)`<Stm* stms> <Expr e>`, CId cls, Scope cScope) 
  = compileBody((Body)`<Stm* stms> <Expr e>;`, cls, cScope);

str compileBody((Body)`<Stm* stms> <Stm s>`, CId cls, Scope cScope) 
  = intercalate("\n", [ compileStm(s1, cls, cScope) | s1 <- stms] + [ compileStm(s, cls, cScope) ]);

/*
 * Statements
 * TODO: pass refs and current scope down.
 */
 
str compileStm((Stm)`<Expr e>;`, CId cls, Scope cScope) 
  = "$ret = <compileExpr(e, cls, cScope)>;";

str compileStm((Stm)`var <Id x> = <Expr e>;`, CId cls, Scope cScope) {
  // if the current capture scope contains a scope which defines methods...
  if (capturedDef(x@\loc)) {
     return "$O[] <x> = $box($ret = <compileExpr(e, cls, cScope)>);";
  }
  return "$O <x> = $ret = <compileExpr(e, cls, cScope)>;";
}
  
str compileStm((Stm)`if <Expr e> then <Body b1> else <Body b2> end`, CId cls, Scope cScope) 
  = "if ($truth(<compileExpr(e, cls, cScope)>)) {
    '  <compileBody(b1, cls, cScope)>
    '}
    'else {
    '  <compileBody(b2, cls, cScope)>
    '}";
    
str compileStm((Stm)`if <Expr e> then <Body b1> end`, CId cls, Scope cScope) 
  = "if ($truth(<compileExpr(e, cls, cScope)>)) {
    '  <compileBody(b1, cls, cScope)>
    '}";
    
str compileStm((Stm)`case <Expr c> of <Case* cs> end`, CId cls, Scope cScope)
  = compileStm((Stm)`case <Expr c> of <Case* cs> default: nil end`, cls, cScope);     

str compileStm(s:(Stm)`case <Expr c> of <Case* cs> default: <Body d> end`, CId cls, Scope cScope)
  = "{ $O <x> = <compileExpr(c, cls, cScope)>;
    '  <l>: do {
    '  <for ((Case)`<Expr e>: <Body b>` <- cs) {>
    '    if ($truth(<compileExpr(e, cls, cScope)>._eq(<x>))) {
    '      <compileBody(b, cls, cScope)>
    '      break <l>;
    '    }
    '  <}>
    '    <compileBody(d, cls, cScope)>
    '  } while (false); 
    '}"
  when 
    str x := "$case<s@\loc.offset>",
    str l := "$caseLabel<s@\loc.offset>";


str compileStm((Stm)`while <Expr e> do <Body b> end`, CId cls, Scope cScope)
  = "while ($truth(<compileExpr(e, cls, cScope)>)) {
    '  <compileBody(b, cls, cScope)>
    '}";
    
str compileStm((Stm)`do <Body b> while <Expr c>;`, CId cls, Scope cScope)
  = "do {
    '  <compileBody(b, cls, cScope)>
    '} while ($truth(<compileExpr(c, cls, cScope)>));";

str compileStm((Stm)`for <Id x> in <Expr iter> do <Body b> end`, CId cls, Scope cScope)
  = "for($O <x>: $iter(<compileExpr(iter, cls, cScope)>)) {
    '  <compileBody(b, cls, cScope)>
    '}";

str compileStm((Stm)`for <ForBind fb>, <{ForBind ","}+ fbs> do <Body b> end`, CId cls, Scope cScope) 
  = compileStm((Stm)`for <ForBind fb> do for <{ForBind ","}+ fbs> do <Body b> end end`, cls, cScope);


str compileStm((Stm)`continue;`, CId cls, Scope cScope) = "continue;";

str compileStm((Stm)`break;`, CId cls, Scope cScope) = "break;";

str compileStm((Stm)`return <Expr e>;`, CId cls, Scope cScope)
  = "return <compileExpr(e, cls, cScope)>;";
  
// todo: try catch

/*
 * Expressions
 */
 
bool capturedDef(loc x) 
  = (<Scope useScope, loc use, x, str _> <- _REFS &&
      <Scope defScope, x, x, str _> <- _REFS &&
      <Scope captureScope, loc d, d, "$method"> <- _REFS &&
      contains(captureScope, useScope) &&
      !contains(captureScope, defScope));

bool capturedUse(loc x) = capturedDef(d)
  when bprintln(x), <Scope _, x, loc d, str _> <- _REFS;

// bug: desugared vars still have wrong origins.
default bool capturedUse(loc x) = false;
 
// if the declaration of x is outside of the current scope, do x[0].
str compileExpr((Expr)`<Id x>`, CId cls, Scope cScope) {
  loc use = x@\loc;
  
  /*
  if (<Scope s, loc d, d, "$method"> <- _REFS, contains(cScope, s), cScope != s,
       <Scope svar, loc uvar, loc dvar, str _> <- _REFS, dvar == x@\loc, contains(s, svar)) {*/
  if (capturedUse(use)) {
    return "<x>[0]";
  }
  return "<x>";
}
// when to do x[0]???
// when we're in an anonymous class, and the decl of x is outside of it.

str compileExpr((Expr)`@<ID x>`, CId cls, Scope cScope) = "<cls>.this._<x>";

str compileExpr((Expr)`<Expr l> || <Expr r>`, CId cls, Scope cScope)
  = "$or(<compileExpr(l, cls, cScope)>, () -\> <compileExpr(r, cls, cScope)>)"; 

str compileExpr((Expr)`<Expr l> && <Expr r>`, CId cls, Scope cScope)
  = "$and(<compileExpr(l, cls, cScope)>, () -\> <compileExpr(r, cls, cScope)>)"; 

str compileExpr((Expr)`<Expr c> ? <Expr t> : <Expr e>`, CId cls, Scope cScope)
  = "$ite(<compileExpr(l, cls, cScope)>, () -\> <compileExpr(t, cls, cScope)>, () -\> <compileExpr(e, cls, cScope)>)"; 

str compileExpr((Expr)`@<ID x> = <Expr e>`, CId cls, Scope cScope)
  = "<cls>.this._<x> = <compileExpr(e, cls, cScope)>";

// todo: if capture do x[0]
str compileExpr((Expr)`<Id x> = <Expr e>`, CId cls, Scope cScope) {
  if (capturedUse(x@\loc)) {
    return "<x>[0] = <compileExpr(e, cls, cScope)>";  
  }
  return "<x> = <compileExpr(e, cls, cScope)>";
}

str compileExpr((Expr)`self`, CId cls, Scope cScope) = "($O)<cls>.this";

str compileExpr((Expr)`super.<DId d>(<{Expr ","}* es>)`, CId cls, Scope cScope)
  = "super.<mangle(d)>(<intercalate(", ", [ compileExpr(arg, cls, cScope) | arg <- es ])>)";

default str compileExpr(Expr e, CId cls, Scope cScope)
  = "(<compileExpr(r, cls, cScope)>).<mangle(d)>(<intercalate(", ", [ compileExpr(arg, cls, cScope) | arg <- es ])>)"
  when
    <Expr r, DId d, {Expr ","}* es> := destructure(e);

str compileExpr((Expr)`<Bool b>`, CId cls, Scope cScope) = "$bool(<b>)";

str compileExpr((Expr)`<Str s>`, CId cls, Scope cScope) = "$str(<s>)";

str compileExpr((Expr)`<Int  s>`, CId cls, Scope cScope) = "$int(<s>)";

str compileExpr((Expr)`:<DId x>`, CId cls, Scope cScope) = "$sym(\"<x>\")";

str compileExpr((Expr)`:<Str x>`, CId cls, Scope cScope) = "$sym(<x>)";


str cid2methodName((CId)`<SId x>`) = "$<x>";
str cid2methodName((CId)`<MId m>/<SId x>`) = "<mid2methodName(m)>$<x>";
str mid2methodName((MId)`<SId x>`) = "$<x>";
str mid2methodName((MId)`<{PId "/"}+ path>/<SId x>`) 
  = "$<intercalate("$", [ "<p>" | p <- path ])><x>";

// todo: dots
// TODO: factor out duplication
str compileExpr(new:(Expr)`new <CId cid>(<{Expr ","}* es>)`, CId cls, Scope cScope) 
  = "$new(<cid2java(x)>(), <obj> -\> { <obj>.initialize(<intercalate(", ", [ compileExpr(e, cls, cScope) | e <- es ])>); return <obj>; })"
  when 
    loc l := cid@\loc, 
    <_, l, _, str x> <- _REFS,
    str obj := "$obj<new@\loc.offset>";


set[Id] captured(new:(Expr)`new <CId cid>(<{Expr ","}* _>){ <Member* ms> }`, Refs refs)
  = { x | /(Expr)`<Id x>` := ms, loc use := x@\loc, <loc _, use, loc def, str label> <- refs,
           !contains(new@\loc, def) };

// Ok, this is a hack, but we need to know the current module id here
// for now we extract it from the loc...

str compileExpr(new:(Expr)`new <CId cid>(<{Expr ","}* es>) { <Member* ms> }`, CId cls, Scope cScope) 
  = "$new(<cid2java(a)>(), <obj> -\> { <assignCaptures(new, obj, anonymous(new@\loc), _REFS)><obj>.initialize(<intercalate(", ", [ compileExpr(e, cls, cScope) | e <- es ])>); return <obj>; })"
  when 
    str f := new@\loc.file,
    str a := "<f[0..findLast(f, ".nomen")]>/<anonymous(new@\loc)>",
    str obj := "$obj<new@\loc.offset>";

str assignCaptures(Expr e, str obj, str class, Refs refs)
  = intercalate("", [ "((<class>\<$O\>)<obj>).<var> = <var>; " | var <- captured(e, refs) ]);
  
str compileExpr((Expr)`nil`, CId cls) = "$nil()";

str compileExpr((Expr)`[<{Expr ","}* es>]`, CId cls, Scope cScope)
  = "$array(<intercalate(", ", [ compileExpr(e, cls) | e <- es ])>)";

str compileExpr((Expr)`{<{KeyVal ","}* kvs>}`, CId cls, Scope cScope)
  = "$dict(<intercalate(", ", [ *compileKeyVal(kv, cls) | kv <- kvs ])>)";

list[str] compileKeyVal((KeyVal)`<Id x>: <Expr e>`, CId cls, Scope cScope)
  = [compileExpr((Expr)`:<Id x>`, cls), compileExpr(e, cls)];  

list[str] compileKeyVal((KeyVal)`<Expr k> =\> <Expr e>`, CId cls, Scope cScope)
  = [compileExpr(k, cls), compileExpr(e, cls)];  
  
  