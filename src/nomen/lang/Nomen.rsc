module nomen::lang::Nomen

extend lang::std::Layout;
import util::IDE;
import IO;

start syntax Module
  = "module" MId name Decl* decls
  ;

// MId
// Id -> module name
// x/y/Z : x and y are directories

syntax Decl
  = \import: "import" MId
  | class: "class" CId name Extends? extends Member* members
  //| "trait" CId name Member* members
  ;

syntax Extends
  = ":" CId
  //| ":" CId "with" {CId ","}+
  //| "with" {CId ","}+
  ;

syntax Member
// we need the colon otherwise can be amb with closure
  = "def" DId "(" {Id ","}* ")" ":" Body 
  | "def" DId ":" Body // sugar
  //| "redef" DId "(" {Id ","}* ")" ":" Body 
  //| "redef" DId ":" Body // sugar
  ;  
  
/*
statements are separator by semi, so that idioms like
lst.filter(x) {x > 3} work
lst.reduce(1, (x, r) { x + r })

for i in [0..10] do 
  
end
*/  
  
syntax ForBind
  = Id "in" Expr
  ;  
  
syntax Catch
  = "catch" CId class Id var ":" Body 
  ;
  
syntax Case
  = Expr ":" Body
  ;

syntax Default
  = "default" ":" Body
  ;
    
syntax Stm
  = expr: Expr ";"
  | decl: "var" Id ";"  // sugar
  | declInit: "var" Id "=" Expr ";"  
  | ifThenElse: "if" Expr "then" Body "else" Body "end"
  | ifThen: "if" Expr "then" Body "end"
  | whileDo: "while" Expr "do" Body "end"
  | doWhile: "do" Body "while" Expr ";"
  | forIn: "for" {ForBind ","}+ "do" Body "end"
  | tryCatch: "try" Body Catch+ "end"
  | tryFinally: "try" Body "finally" Body "end"
  | tryCatchFinally: "try" Body Catch+ "finally" Body "end"
  | caseOf: "case" Expr "of" Case* Default? "end"
  // todo: labeled continue an break?
  | cont: "continue" ";"
  | brk: "break" ";"
  | retNil: "return" ";"  // sugar
  | retExpr: "return" Expr ";" 
  ; 

syntax DId
  = id: Id!mark // TODO: non-modular wrt testing language
  | setAttr: Id "=" 
  | prefixPlus: "@+"
  | prefixMinus: "@-"
  | prefixTilde: "@~"
  | prefixBang: "@!"
  | star: "*"
  | slash: "/"
  | percent: "%"
  | plus: "+"
  | minus: "-"
  | amp: "&"
  | pipe: "|"
  | tilde2: "~"
  | hat: "^"
  | ggt: "\>\>"
  | llt: "\<\<"
  | gt: "\>"
  | geq: "\>="
  | leq: "\<="
  | lt: "\<"
  | eq: "=="
  | neq: "!="
  | setElt: "[]="
  | getElt: "[]"
  ;

syntax Body
  = Stm* Stm // note: non-empty, because otherwise closure amb with empty map
  | Stm* Expr
  | ";" // never empty otherwise block is amb with dict
  ;

syntax Block
  = block0: "{" Body "}" // sugar
   
  | block: "(" { Id ","}* params ")" "{" Body body "}" 
  ;
  
  
syntax KeyVal
  = sym: Id ":" Expr
  | exp: Expr "=\>" Expr
  ;
  
syntax Expr
  = var: Id
  | field: FId
  | new: "new" CId >> [(] "(" {Expr ","}* ")"
  | new0: "new" CId // sugar
  | newAnonObj: "new" "{" Member* members "}"
  | newAnon0: "new" CId "{" Member* members "}"
  | newAnon: "new" CId >> [(] "(" {Expr ","}* ")" "{" Member* members "}"
  | lit: Lit
  | bracket brack: "(" Expr ")"
  | self: "self"
  | superSend: "super" "." DId  >> [(] "(" {Expr ","}* ")"
  | superSendNoArgs: "super" "." DId // sugar
  | send: Expr "." Id  >> [(] "(" {Expr ","}* ")"
  | sendNoArgs: Expr "." Id // sugar
  | selfSend: Id >> [(] "(" {Expr ","}* ")" 
  | getElt: Expr [\n\t\ ] !<< "[" Expr "]"
  > right sendLit: Expr "." Id [\n\t\ ] << Expr // sugar
  | selfSendLit: Id  [\n\t\ ] << Expr // sugar
  | sendLitParen: Expr "." Id >> [(] "(" {Expr ","}* ")" [\n\t\ ] << Expr // sugar
  | selfSendLitParen: Id >> [(] "(" {Expr ","}* ")"  [\n\t\ ] << Expr // sugar
  | newLit: "new" CId [\n\t\ ] << Expr // sugar
  > prefixPlus: "+" !>> [\n\t\ ]Expr
  | prefixMin: "-" !>> [\n\t\ ] Expr
  | prefixBang: "!" !>> [\n\t\ ] Expr
  | prefixTilde: "~" !>> [\n\t\ ] Expr
  > left (
    star: Expr "*" Expr 
  | slash: Expr [a-zA-Z0-9_\>] !<< "/" Expr
  | percent: Expr "%" Expr
  ) 
  > left (
    plus: Expr "+" Expr 
  | min: Expr "-" Expr
  )
  > left (
    ggt: Expr "\>\>" Expr
  | llt: Expr "\<\<" Expr
  )
  > left (
    gt: Expr "\>" Expr 
  | geq: Expr "\>=" Expr
  | lt: Expr "\<" Expr 
  | leq: Expr "\<=" Expr
  )
  >
  left (
    eq: Expr "==" Expr
  | neq: Expr "!=" Expr
  )
  > left tilde:  Expr "~" Expr // not in Java
  > left amp: Expr "&" Expr
  > left hat: Expr "^" Expr
  > left pipe: Expr "|" Expr
  > left and: Expr "&&" Expr 
  > left or: Expr "||" Expr 
  > right cond: Expr "?" Expr ":" Expr
  > right infix: Expr (Id >> [:] ":" >> [\n\t\ ]) Expr
  > fieldAssign: FId "=" Expr 
  | varAssign: Id "=" Expr
  | right ( 
    right setElt: Expr!varAssign!fieldAssign!infix!cond!or!and!pipe!hat!amp!tilde
                   !neq!eq!leq!lt!geq!gt!ggt!llt!min!plus!slash!star!percent
                   !prefixPlus!prefixMin!prefixBang!prefixTilde!selfSendLit
                   !sendLit!newLit!setAttr  [\n\t\ ] !<< "[" Expr "]" "=" Expr
   | right setAttr: Expr !varAssign!fieldAssign!infix!cond!or!and!pipe!hat!amp!tilde
                   !neq!eq!leq!lt!geq!gt!ggt!llt!min!plus!slash!star!percent
                   !prefixPlus!prefixMin!prefixBang!prefixTilde!selfSendLit
                   !sendLit!newLit!setElt "." Id "=" Expr 
   )
  ;

syntax Lit
  = \bool: Bool
  | \str: Str
  | \int: Int
  | sym: Sym
  | nil: "nil"
  | block: Block
  | array: "[" {Expr ","}* "]"
  | dict: "{" {KeyVal ","}* "}"
  ;

syntax Bool
  = \true: "true"
  | \false: "false"
  ;

lexical Int
  = [\-]? [0-9] !<< [0-9]+ !>> [0-9]
  ;
  
lexical Str
  = [\"] StrChar* [\"]
  ;
  
lexical StrChar
  = ![\"\\]
  | [\\][\"]
  ;

syntax Sym
  = ":" [:] << Str
  | ":" [:] << DId
  ;

syntax FId
  = "@" [@] << ID
  ;
  
syntax PId
  = Id >> [/]
  ;  
  
syntax MId
  = qualified: {PId "/"}+ >> [/] "/" [/] << SId
  | simple: SId
  ;
  
syntax CId
  = unqualified: SId class
  | qualified: MId module >> [/]  "/" [/] << SId class
  ;  
  
keyword Reserved
  = "class" | "module" | "def" | "self" | "true" | "false" | "if" | "while" 
  | "then" | "else" | "end" | "do" | "continue" | "break" | "return"
  | "nil" | "import" | "default" | "var" | "super"
  ;


syntax Id
  = ID \ Reserved
  ;

lexical ID
  = ([a-zA-Z_0-9] !<< [a-z][a-zA-Z_0-9]* !>> [a-zA-Z_0-9]) 
  | "\'" [a-zA-Z][a-zA-Z_0-9]* !>> [a-zA-Z_0-9]
  ;
  
lexical SId
  = ([a-zA-Z_0-9] !<< [A-Z][a-zA-Z_0-9]* !>> [a-zA-Z_0-9])
  ;
  
start syntax TestCheck
  = "testing" Id name TCTest* tests
  ;
  
syntax TCTest
  = @Foldable "test" Str name "{" Module* modules "}" 
  ;
  
//syntax TId
//  = @category="Variable" Id
//  ;
  
syntax Mark[&T]
  = error: "$" "error" "(" &T ")"
  | warning: "$" "warning" "(" &T ")"
  | use: "$" "use" "(" &T ")"
  | def: "$" "def" "(" &T ")"
  ;
  

syntax CId
  = mark: Mark[CId]
  ;  

syntax Id
  = mark: Mark[Id]
  ;  
  
syntax MId
  = mark: Mark[MId]
  ;
  
syntax DId
  = mark: Mark[DId]
  ;
  
alias Check = tuple[rel[loc scope, loc use, loc def, str label], set[Message]](Module* ms);
  
void registerTestCheck(Check check) {
   registerLanguage("NomenTest", "nt", start[TestCheck](str src, loc org) {
     return parse(#start[TestCheck], src, org);
   });
   
   registerContributions("NomenTest", {
     builder(set[Message] (start[TestCheck] tree)  {
        if (start[TestCheck] tc := tree) {
          return runTests(tc, check);
        }
        return {error("Not a NomenTest", pt@\loc)};
      })
   });
}

set[Message] runTests(start[TestCheck] tc, Check check) 
  = ( {} | it + runTest(t, check) | t <- tc.top.tests );

set[Message] runTest(TCTest t, Check check) {
  errors  = {};
  warnings = {};
  uses = {};
  defs = {};
  t2 = visit (t) {
    case (CId)`$error(<CId cid>)`: {
      errors += {cid@\loc};
      insert cid;
    } 
    case (MId)`$error(<MId mid>)`: {
      errors += {mid@\loc};
      insert mid;
    } 
    case (DId)`$error(<DId did>)`: {
      errors += {did@\loc};
      insert did;
    } 
    case (Id)`$error(<Id x>)`:{
      errors += {x@\loc};
      insert x;
    }
    case (CId)`$warning(<CId cid>)`: {
      warnings += {cid@\loc};
      insert cid;
    } 
    case (MId)`$warning(<MId mid>)`: {
      warnings += {mid@\loc};
      insert mid;
    } 
    case (DId)`$warning(<DId did>)`: {
      warnings += {did@\loc};
      insert did;
    } 
    case (Id)`$warning(<Id x>)`:{
      warnings += {x@\loc};
      insert x;
    }
    case (Id)`$use(<Id x>)`:{
      uses += {x@\loc};
      insert x;
    }
    case (CId)`$use(<CId x>)`:{
      uses += {x@\loc};
      insert x;
    }
    case (MId)`$use(<MId x>)`:{
      uses += {x@\loc};
      insert x;
    }
    case (DId)`$use(<DId x>)`:{
      uses += {x@\loc};
      insert x;
    }
    case (Id)`$def(<Id x>)`:{
      defs += {x@\loc};
      insert x;
    }
    case (CId)`$def(<CId x>)`:{
      defs += {x@\loc};
      insert x;
    }
    case (MId)`$def(<MId x>)`:{
      defs += {x@\loc};
      insert x;
    }
    case (DId)`$def(<DId x>)`:{
      defs += {x@\loc};
      insert x;
    }
  };
  
  
  <refs, checked> = check(t2.modules);
  msgs = {};
  done = {};
  
  expectedRefs = { <u, d> | u <- uses, d <- defs };
    
  for (<loc u, loc d> <- expectedRefs) {
    if (<_, u, d, _> <- refs) {
       msgs += {info("OK", u)};
    }
    else {
      msgs += {error("Incorrect reference", u)};
    }
  } 
  
  void recordFailureIfAny(loc mloc, loc x) {
    if (error(str label, loc l) <- checked, l == x) {
      done += {l};
      msgs += {info("OK: <label>", mloc)};
      return;
    }
    msgs += {error("Expected error", mloc)};
  }
  
  visit (t) {
    case m:(CId)`$error(<CId cid>)`: recordFailureIfAny(m@\loc, cid@\loc);
    case m:(MId)`$error(<MId mid>)`: recordFailureIfAny(m@\loc, mid@\loc);
    case m:(DId)`$error(<DId did>)`: recordFailureIfAny(m@\loc, did@\loc);
    case m:(Id)`$error(<Id x>)`: recordFailureIfAny(m@\loc, x@\loc);
  };
  
  msgs += { msg[msg="Expected: <msg.msg>"] | Message msg <- checked, msg.at notin done };
  
  return msgs;
} 
  
