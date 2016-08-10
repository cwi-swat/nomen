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
   
   bool hasMain = (<_, class("Main"), _> <- env);
   
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
          '  <for (Decl d <- m.decls, d has members) {>
          '  <compileClass(d, m.name, refs)>
          '  <}>
          '  
          '  <for (/Expr e := m, isAnonNew(e)) {>
          '  <compileAnonClass(e, m.name, refs)>
          '  <}>
          '  
          '  <if (Decl d <- m.decls, d has name, d.name == (CId)`Main`) {>
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

bool isAnonNew((Expr)`new {<Member* ms>}`) = true;
bool isAnonNew((Expr)`new <CId _>(<{Expr ","}* _>) {<Member* ms>}`) = true;
default bool isAnonNew(Expr _) = false;

str compileClass((Decl)`class <CId c> <Member* ms>`, MId mid, Refs refs) 
  = compileClass((Decl)`class <CId c>: <CId d> <Member* ms>`, mid, refs)
  when CId d := [CId]"<KERNEL>/Obj";

str compileClass((Decl)`class <CId c>: <CId d> <Member* ms>`, MId mid, Refs refs) {
  flds = { x |  /(FId)`@<Id x>` := ms };
  
  super = "";
  l = d@\loc;
  if (<_, l, _, str s> <- refs) {
    super = s;
  }
  else {
    super = "<KERNEL>/Obj"; // sensible (?) default
  } 
  
  
  return "abstract class <c>\<$O extends <mid2java("<mid>")>\<$O\>\> extends <mid2java(super)>\<$O\> implements <mid2java("<mid>")>\<$O\> {
         '  <for (x <- flds) {>protected $O <x>;
         '  <}>
         '
         '  public <c>() { 
         '    super(); 
         '    <for (x <- flds) {>this.<x> = $nil();
         '    <}>
         '  }
         '  <for (m <- ms) {><compileMethod(mid, c, m)>
         '  <}>
         '}"; 
}

str compileAnonClass(e:(Expr)`new {<Member* ms>}`, MId mid, Refs refs)  
  = compileClass((Decl)`class <CId anon> <Member* ms>`, mid, refs)
  when anon := [CId]anonymous(e@\loc);

str compileAnonClass(e:(Expr)`new <CId c>(<{Expr ","}* es>) {<Member* ms>}`, MId mid, Refs refs)  
  = compileClass((Decl)`class <CId anon>: <CId c> <Member* ms>`, mid, refs)
  when anon := [CId]anonymous(e@\loc);
  

str compileMethod(MId mid, CId cls, (Member)`def <DId d>: <Body b>`)
  = compileMethod(mid, cls, (Member)`def <DId d>(): <Body b>`);

str compileMethod(MId mid, CId cls, (Member)`def <DId d>(<{Id ","}* fs>): <Body b>`) {
  return "@Override
         'public $O <mangle(d)>(<intercalate(", ", [ "$O <f>" | f <- fs ])>) {
         '  $O $ret = $nil();
         '  <compileBody(b, cls)>
         '  return $ret;
         '}";
}


str compileBody((Body)`;`, CId cls) = "";

str compileBody((Body)`<Stm* stms> <Expr e>`, CId cls) 
  = compileBody((Body)`<Stm* stms> <Expr e>;`, cls);

str compileBody((Body)`<Stm* stms> <Stm s>`, CId cls) 
  = intercalate("\n", [ compileStm(s1, cls) | s1 <- stms, bprintln(s1) ] + [ compileStm(s, cls) ])
  when bprintln("s = <s>");

/*
 * Statements
 * TODO: pass refs and current scope down.
 */
 
str compileStm((Stm)`<Expr e>;`, CId cls) 
  = "$ret = <compileExpr(e, cls)>;";

str compileStm((Stm)`var <Id x>;`, CId cls) 
  = compileStm((Stm)`var <Id x> = nil;`, cls);
  
// TODO: if there's reference to x in a scope != current scope, make array.
str compileStm((Stm)`var <Id x> = <Expr e>;`, CId cls)
  = "$O <x> = $ret = <compileExpr(e, cls)>;";
  
str compileStm((Stm)`if <Expr e> then <Body b1> else <Body b2> end`, CId cls) 
  = "if ($truth(<compileExpr(e, cls)>)) {
    '  <compileBody(b1, cls)>
    '}
    'else {
    '  <compileBody(b2, cls)>
    '}";
    
str compileStm((Stm)`if <Expr e> then <Body b1> end`, CId cls) 
  = "if ($truth(<compileExpr(e, cls)>)) {
    '  <compileBody(b1, cls)>
    '}";
    
str compileStm((Stm)`case <Expr c> of <Case* cs> end`, CId cls)
  = compileStm((Stm)`case <Expr c> of <Case* cs> default: nil end`, cls);     

str compileStm(s:(Stm)`case <Expr c> of <Case* cs> default: <Body d> end`, CId cls)
  = "{ $O <x> = <compileExpr(c, cls)>;
    '  <l>: do {
    '  <for ((Case)`<Expr e>: <Body b>` <- cs) {>
    '    if ($truth(<compileExpr(e, cls)>._eq(<x>))) {
    '      <compileBody(b, cls)>
    '      break <l>;
    '    }
    '  <}>
    '    <compileBody(d, cls)>
    '  } while (false); 
    '}"
  when 
    str x := "$case<s@\loc.offset>",
    str l := "$caseLabel<s@\loc.offset>";


str compileStm((Stm)`while <Expr e> do <Body b> end`, CId cls)
  = "while ($truth(<compileExpr(e, cls)>)) {
    '  <compileBody(b, cls)>
    '}";
    
str compileStm((Stm)`do <Body b> while <Expr c>;`, CId cls)
  = "do {
    '  <compileBody(b, cls)>
    '} while ($truth(<compileExpr(c, cls)>));";

str compileStm((Stm)`for <Id x> in <Expr iter> do <Body b> end`, CId cls)
  = "for($O <x>: $iter(<compileExpr(iter, cls)>)) {
    '  <compileBody(b, cls)>
    '}";

str compileStm((Stm)`for <ForBind fb>, <{ForBind ","}+ fbs> do <Body b> end`, CId cls) 
  = compileStm((Stm)`for <ForBind fb> do for <{ForBind ","}+ fbs> do <Body b> end end`, cls);


str compileStm((Stm)`continue;`, CId cls) = "continue;";

str compileStm((Stm)`break;`, CId cls) = "break;";

str compileStm((Stm)`return;`, CId cls) 
  = compileStm((Stm)`return nil;`, cls);

str compileStm((Stm)`return <Expr e>;`, CId cls)
  = "return <compileExpr(e, cls)>;";
  
// todo: try catch, case of

/*
 * Expressions
 */
 
// todo: if capture, do x[0]
// if the declaration of x is outside of the current scope, do x[0].
str compileExpr((Expr)`<Id x>`, CId cls) = "<x>";

str compileExpr((Expr)`@<Id x>`, CId cls) = "<cls>.this.<x>";

str compileExpr((Expr)`<Expr l> || <Expr r>`, CId cls)
  = "$or(<compileExpr(l, cls)>, () -\> <compileExpr(r, cls)>)"; 

str compileExpr((Expr)`<Expr l> && <Expr r>`, CId cls)
  = "$and(<compileExpr(l, cls)>, () -\> <compileExpr(r, cls)>)"; 

str compileExpr((Expr)`<Expr c> ? <Expr t> : <Expr e>`, CId cls)
  = "$ite(<compileExpr(l, cls)>, () -\> <compileExpr(t, cls)>, () -\> <compileExpr(e, cls)>)"; 

str compileExpr((Expr)`@<Id x> = <Expr e>`, CId cls)
  = "<cls>.this.<x> = <compileExpr(e, cls)>";

// todo: if capture do x[0]
str compileExpr((Expr)`<Id x> = <Expr e>`, CId cls)
  = "<x> = <compileExpr(e, cls)>";

str compileExpr((Expr)`self`, CId cls) = "($O)<cls>.this";

str compileExpr((Expr)`super.<DId d>(<{Expr ","}* es>)`, CId cls)
  = "super.<mangle(d)>(<intercalate(", ", [ compileExpr(arg, cls) | arg <- es, bprintln("arg: <arg>") ])>)";

default str compileExpr(Expr e, CId cls)
  = "(<compileExpr(r, cls)>).<mangle(d)>(<intercalate(", ", [ compileExpr(arg, cls) | arg <- es, bprintln("arg: <arg>") ])>)"
  when bprintln("e = <e>"),
    <Expr r, DId d, {Expr ","}* es> := destructure(e);

str compileExpr((Expr)`<Bool b>`, CId cls) = "$bool(<b>)";

str compileExpr((Expr)`<Str s>`, CId cls) = "$str(<s>)";

str compileExpr((Expr)`<Int  s>`, CId cls) = "$int(<s>)";

str compileExpr((Expr)`:<DId x>`, CId cls) = "$sym(\"<x>\")";

str compileExpr((Expr)`:<Str x>`, CId cls) = "$sym(<x>)";


str cid2methodName((CId)`<SId x>`) = "$<x>";
str cid2methodName((CId)`<MId m>/<SId x>`) = "<mid2methodName(m)>$<x>";
str mid2methodName((MId)`<SId x>`) = "$<x>";
str mid2methodName((MId)`<{PId "/"}+ path>/<SId x>`) 
  = "$<intercalate("$", [ "<p>" | p <- path ])><x>";

// todo: dots
// TODO: factor out duplication
str compileExpr(new:(Expr)`new <CId cid>(<{Expr ","}* es>)`, CId cls) 
  = "$new(<cid2java(x)>(), <obj> -\> { <obj>.initialize(<intercalate(", ", [ compileExpr(e, cls) | e <- es ])>); return <obj>; })"
  when 
    loc l := cid@\loc, 
    <_, l, _, str x> <- _REFS,
    str obj := "$obj<new@\loc.offset>";


// Ok, this hack, but we need to know the current module id here
// for now we extract it from the loc...
str compileExpr(new:(Expr)`new { <Member* ms> }`, CId cls)
  = "$new(<cid2java(a)>(), <obj> -\> { <obj>.initialize(); return <obj>; })"
  when 
    str f := new@\loc.file,
    str a := "<f[0..findLast(f, ".nomen")]>/<anonymous(new@\loc)>",
    str obj := "$obj<new@\loc.offset>";

str compileExpr(new:(Expr)`new <CId cid>(<{Expr ","}* es>) { <Member* ms> }`, CId cls) 
  = "$new(<cid2java(a)>(), <obj> -\> { <obj>.initialize(<intercalate(", ", [ compileExpr(e, cls) | e <- es ])>); return <obj>; })"
  when 
    str f := new@\loc.file,
    str a := "<f[0..findLast(f, ".nomen")]>/<anonymous(new@\loc)>",
    str obj := "$obj<new@\loc.offset>";

str compileExpr((Expr)`nil`, CId cls) = "$nil()";

str compileExpr((Expr)`[<{Expr ","}* es>]`, CId cls)
  = "$array(<intercalate(", ", [ compileExpr(e, cls) | e <- es ])>)";

str compileExpr((Expr)`{<{KeyVal ","}* kvs>}`, CId cls)
  = "$dict(<intercalate(", ", [ *compileKeyVal(kv, cls) | kv <- kvs ])>)";

list[str] compileKeyVal((KeyVal)`<Id x>: <Expr e>`, CId cls)
  = [compileExpr((Expr)`:<Id x>`, cls), compileExpr(e, cls)];  

list[str] compileKeyVal((KeyVal)`<Expr k> =\> <Expr e>`, CId cls)
  = [compileExpr(k, cls), compileExpr(e, cls)];  
  
str compileExpr((Expr)`{<Body b>}`, CId cls) 
  = compileExpr((Expr)`() {<Body b>}`, cls);

str compileExpr((Expr)`(<{Id ","}* fs>) {<Body b>}`, CId cls)
  = "$block(new <mid2java(KERNEL)>.Block\<$O\>() {
    '  @Override
    '  public $O call(<intercalate(", ", [ "$O <f>" | f <- fs ])>) {
    '    $O $ret = $nil();
    '    <compileBody(b, cls)>
    '    return $ret;
    '  }
    '})";
  