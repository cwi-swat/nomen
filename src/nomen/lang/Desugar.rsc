module nomen::lang::Desugar

import nomen::lang::Nomen;
import ParseTree;

start[Module] desugar(start[Module] m) 
  = m[top=desugar(m.top)];
  
Module desugar(Module m) { 
  return visit (m) {
    case Decl d => desugar(d)
    case Member d => desugar(d)
    case Expr e => desugar(e)
    case Stm  s => desugar(s)
    case Body b => desugar(b)
  }
}

Decl desugar(d:(Decl)`class <CId c> <Member* ms>`)
  = (Decl)`class <CId c>: nomen/lang/Kernel/Obj <Member* ms>`[@\loc=d@\loc]
  when c != (CId)`nomen/lang/Kernel/Obj`;

default Decl desugar(Decl d) = d;

// NB: all one step, so desugaring can be one traversal.
Member desugar(m:(Member)`def <DId d>: <Body b>`)
  = (Member)`def <DId d>(): <Body b>`[@\loc=m@\loc];

default Member desugar(Member m) = m;

Stm desugar(s:(Stm)`var <Id x>;`)
  = (Stm)`var <Id x> = nil;`[@\loc=s@\loc];

Stm desugar(s:(Stm)`return;`)
  = (Stm)`return nil;`[@\loc=s@\loc];

default Stm desugar(Stm s) = s;

Body desugar(b:(Body)`<Stm* stms> <Expr e>`)
  = (Body)`<Stm* stms> <Expr e>;`[@\loc=b@\loc];

default Body desugar(Body b) = b;

Expr desugar((Expr)`new <CId c>`)
  = (Expr)`new <CId c>()`;

Expr desugar((Expr)`new <CId c> <Expr e>`)
  = (Expr)`new <CId c>(<Expr e>)`;

Expr desugar((Expr)`<Id m> <Expr e>`)
  = (Expr)`self.<Id m>(<Expr e>)`;

Expr desugar((Expr)`<Id m>(<{Expr ","}* es>) <Expr e>`)
  = (Expr)`self.<Id m>(<{Expr ","}* es>, <Expr e>)`;

Expr desugar((Expr)`<Id m>(<{Expr ","}* es>)`)
  = (Expr)`self.<Id m>(<{Expr ","}* es>)`;

Expr desugar((Expr)`<Expr e>.<Id m>`)
  = (Expr)`<Expr e>.<Id m>()`;

Expr desugar((Expr)`<Expr e1>.<Id m>(<{Expr ","}* es>) <Expr e2>`)
  = (Expr)`<Expr e1>.<Id m>(<{Expr ","}* es>, <Expr e2>)`;

Expr desugar((Expr)`<Expr e1>.<Id m> <Expr e2>`)
  = (Expr)`<Expr e1>.<Id m>(<Expr e2>)`;

Expr desugar((Expr)`<Expr e1>.<Id m>(<{Expr ","}* es>) <Expr e2>`)
  = (Expr)`<Expr e1>.<Id m>(<{Expr ","}* es>, <Expr e2>)`;

Expr desugar((Expr)`<Expr e1> <Id m>: <Expr e2>`)
  = (Expr)`<Expr e1>.<Id m>(<Expr e2>)`;

Expr desugar((Expr)`super.<DId d>`)
  = (Expr)`super.<DId d>()`;

Expr desugar(e:(Expr)`new <CId c> { <Member* ms> }`)
  = (Expr)`new <CId c>() { <Member* ms> }`[@\loc=e@\loc];

Expr desugar(e:(Expr)`new { <Member* ms> }`)
  = (Expr)`new nomen/lang/Kernel/Obj() { <Member* ms> }`[@\loc=e@\loc];

Expr desugar(e:(Expr)`{<Body b>}`)
  = desugar((Expr)`(){<Body b>}`[@\loc=e@\loc]);

// TODO: this is wrong, because of this/super/and fields....
// how to assign to fields in closures? Maybe not do in desugar.
// [Can make fields public, and then cast to containing class and assign.]
Expr desugar(e:(Expr)`(<{Id ","}* fs>){<Body b>}`)
  = (Expr)`new nomen/lang/Kernel/Block(self) { 
          '  def initialize(myself):
          '     @self = myself; 
          '  def call(<{Id ","}* fs>): <Body b2> 
          '}`[@\loc=e@\loc]
  when b2 := visit (b) { case s:(Expr)`self` => (Expr)`@self`[@\loc=s@\loc] }; 

default Expr desugar(Expr e) = e;
