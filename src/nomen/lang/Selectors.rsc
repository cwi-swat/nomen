module nomen::lang::Selectors

import nomen::lang::Nomen;
import IO;
import String;
import ParseTree;

str escapeKeywords(str x) {
  if (x in {"new", "class", "public", "static", "void", "abstract", "private", "protected"}) {
    return "$_<x>";
  }
  return x;
}

str unquote(str x) {
  if (startsWith(x, "\'")) {
    return x[1..];
  }
  return x;
}

str mangle(str d) = mangle([DId]d);

str mangle((DId)`<Id x>`) = escapeKeywords(unquote("<x>"));
str mangle((DId)`<Id x>=`) = "_set$<unquote("<x>")>";
str mangle((DId)`@+`) = "__plus";
str mangle((DId)`@-`) = "__minus";
str mangle((DId)`@!`) = "__bang";
str mangle((DId)`@~`) = "__bang";
str mangle((DId)`*`) = "_star";
str mangle((DId)`/`) = "_slash";
str mangle((DId)`%`) = "_percent";
str mangle((DId)`+`) = "_plus";
str mangle((DId)`-`) = "_minus";
str mangle((DId)`\>`) = "_gt";
str mangle((DId)`\>=`) = "_geq";
str mangle((DId)`\<=`) = "_leq";
str mangle((DId)`\<`) = "_lt";
str mangle((DId)`==`) = "_eq";
str mangle((DId)`!=`) = "_neq";
str mangle((DId)`|`) = "_pipe";
str mangle((DId)`&`) = "_amp";
str mangle((DId)`~`) = "_tilde";
str mangle((DId)`^`) = "_hat";
str mangle((DId)`\>\>`) = "_ggt";
str mangle((DId)`\<\<`) = "_llt";
str mangle((DId)`[]=`) = "_setElt";
str mangle((DId)`[]`) = "_getElt";

int arity({Expr ","}* es) = ( 0 | it + 1| _ <- es );
int arity({Id ","}* ids) = ( 0 | it + 1| _ <- ids );

alias Selector = tuple[DId sym, int arity];

alias MethodCall = tuple[Expr receiver, DId sym, {Expr ","}* args];


{Expr ","}* none() = es when (Expr)`f(<{Expr ","}* es>)` := (Expr)`f()`;
{Expr ","}* single(Expr e) = es when (Expr)`f(<{Expr ","}* es>)` := (Expr)`f(<Expr e>)`;
{Expr ","}* two(Expr e, Expr f) = es when (Expr)`f(<{Expr ","}* es>)` := (Expr)`f(<Expr e>, <Expr f>)`;

// presumes desugaring
MethodCall destructure((Expr)`<Expr r>.<Id m>(<{Expr ","}* es>)`) = <r, (DId)`<Id m>`[@\loc=m@\loc], es>;
MethodCall destructure(x:(Expr)`super.<DId d>(<{Expr ","}* es>)`) = <(Expr)`self`/*???*/, d, es>;
  
MethodCall destructure(x:(Expr)`+<Expr e>`) = <e, (DId)`@+`[@\loc=x@\loc], none()>;
MethodCall destructure(x:(Expr)`-<Expr e>`) = <e, (DId)`@-`[@\loc=x@\loc], none()>;
MethodCall destructure(x:(Expr)`!<Expr e>`) = <e, (DId)`@!`[@\loc=x@\loc], none()>;
MethodCall destructure(x:(Expr)`~<Expr e>`) = <e, (DId)`@~`[@\loc=x@\loc], none()>;
MethodCall destructure(x:(Expr)`<Expr e>[<Expr f>]`) = <e, (DId)`[]`[@\loc=x@\loc], single(f)>;
MethodCall destructure(x:(Expr)`<Expr e> + <Expr f>`) = <e, (DId)`+`[@\loc=x@\loc], single(f)>;
MethodCall destructure(x:(Expr)`<Expr e> - <Expr f>`) = <e, (DId)`-`[@\loc=x@\loc], single(f)>;
MethodCall destructure(x:(Expr)`<Expr e> * <Expr f>`) = <e, (DId)`*`[@\loc=x@\loc], single(f)>;
MethodCall destructure(x:(Expr)`<Expr e> % <Expr f>`) = <e, (DId)`%`[@\loc=x@\loc], single(f)>;
MethodCall destructure(x:(Expr)`<Expr e> / <Expr f>`) = <e, (DId)`/`[@\loc=x@\loc], single(f)>;
MethodCall destructure(x:(Expr)`<Expr e> \< <Expr f>`) = <e, (DId)`\<`[@\loc=x@\loc], single(f)>;
MethodCall destructure(x:(Expr)`<Expr e> \> <Expr f>`) = <e, (DId)`\>`[@\loc=x@\loc], single(f)>;
MethodCall destructure(x:(Expr)`<Expr e> \<= <Expr f>`) = <e, (DId)`\<=`[@\loc=x@\loc], single(f)>;
MethodCall destructure(x:(Expr)`<Expr e> \>= <Expr f>`) = <e, (DId)`\>=`[@\loc=x@\loc], single(f)>;
MethodCall destructure(x:(Expr)`<Expr e> == <Expr f>`) = <e, (DId)`==`[@\loc=x@\loc], single(f)>;
MethodCall destructure(x:(Expr)`<Expr e> != <Expr f>`) = <e, (DId)`!=`[@\loc=x@\loc], single(f)>;
MethodCall destructure(x:(Expr)`<Expr e> \>\> <Expr f>`) = <e, (DId)`\>\>`[@\loc=x@\loc], single(f)>;
MethodCall destructure(x:(Expr)`<Expr e> \<\< <Expr f>`) = <e, (DId)`\<\<`[@\loc=x@\loc], single(f)>;
MethodCall destructure(x:(Expr)`<Expr e> & <Expr f>`) = <e, (DId)`&`[@\loc=x@\loc], single(f)>;
MethodCall destructure(x:(Expr)`<Expr e> | <Expr f>`) = <e, (DId)`&`[@\loc=x@\loc], single(f)>;
MethodCall destructure(x:(Expr)`<Expr e> ~ <Expr f>`) = <e, (DId)`&`[@\loc=x@\loc], single(f)>;
MethodCall destructure(x:(Expr)`<Expr e>[<Expr f>] = <Expr g>`) = <e, (DId)`[]=`[@\loc=x@\loc], two(f, g)>;
MethodCall destructure(x:(Expr)`<Expr e>.<Id x>  = <Expr f>`) = <e, (DId)`<Id x>=`[@\loc=x@\loc], single(f)>;
MethodCall destructure(x:(Expr)`(<Expr e>)`) = destructure(e);


bool isMethodCall((Expr)`<Id x>`) = false;
bool isMethodCall((Expr)`@<Id x>`) = false;
bool isMethodCall((Expr)`new <CId x>(<{Expr ","}* es>)`) = false;
bool isMethodCall((Expr)`self`) = false;
bool isMethodCall((Expr)`<Expr l> && <Expr r>`) = false;
bool isMethodCall((Expr)`<Expr l> || <Expr r>`) = false;
bool isMethodCall((Expr)`<Expr c> ? <Expr t> : <Expr e>`) = false;
bool isMethodCall((Expr)`<FId x> = <Expr e>`) = false;
bool isMethodCall((Expr)`<Id x> = <Expr e>`) = false;
bool isMethodCall((Expr)`(<Expr e>)`) = isMethodCall(e);
bool isMethodCall((Expr)`<Lit _>`) = false;
default bool isMethodCall(Expr _) = true;
