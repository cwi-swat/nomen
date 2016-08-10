module nomen::lang::Capturing

extend nomen::lang::Nomen;
import nomen::lang::Resolve;

syntax Stm
  = "cvar" Id "=" Expr ";"  
  ;

syntax Expr
  = cref: "cref" "(" Id ")"
  | cassign: "cref" "(" Id ")" "=" Expr
  ;
  
set[Id] captured(new:(Expr)`new { <Member* ms> }`, Refs refs)
  = { x | /(Expr)`<Id x>` := ms, loc use := x@\loc, <loc _, use, loc def, str label> <- refs,
           !contains(new@\loc, def) };

set[Id] captured(new:(Expr)`new <CId cid>(<{Expr ","}* _>){ <Member* ms> }`, Refs refs)
  = { x | /(Expr)`<Id x>` := ms, loc use := x@\loc, <loc _, use, loc def, str label> <- refs,
           !contains(new@\loc, def) };


start[Module] trafoCaptures(loc scope, Expr e, Refs refs) {

  top-down-break visit (e) {
    case e:(Expr)`new { <Member* ms> }`: {
      e.members = visit (ms) {
        
      }
    } 
    case e:(Expr)`new <CId cid>(<{Expr ","}* _>){ <Member* ms> }` => trafoCaptures(e@\loc, e)
    case e:(Expr)`(<{Id ","}* _>) {<Body b>}` => trafoCaptures(e@\loc, e)
  }

}