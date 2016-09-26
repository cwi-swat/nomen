module nomen::lang::Nomen2

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

syntax Trailing
  = Stm!empty!expr
  | Expr!block!brack ";" 
  | Block
  ;

syntax Stm
  = empty: ";"
  | expr: Expr ";" 
  | decl: "var" VId ";"  // sugar
  | declInit: "var" VId "=" Expr ";"  
  | ifThenElse: "if" Expr "then" Body "else" Body "end"
  | ifThen: "if" Expr "then" Body "end"
  | whileDo: "while" Expr "do" Body "end"
  | doWhile: "do" Body "while" Expr ";"
  | forIn: "for" {ForBind ","}+ "do" Body "end"
  | tryCatch: "try" Body Catch+ "end"
  | tryFinally: "try" Body "finally" Body "end"
  | tryCatchFinally: "try" Body Catch+ "finally" Body "end"
  | caseOf: "case" Expr "of" Case* Default? "end"
  | retNil: "return" ";"
  | retExpr: "return" Expr ";" 
  
  // calls with trailing stm
  // whitespace required, after Id, because otherwise f(x){} can be f((x){}) or (f(x)){}

  // no trailing variants are covered by expr statement.  
  | Id [\t\n\ ] << Trailing
  | Expr "." Id [\t\n\ ] << Trailing
  | Expr "." Id >> [(] "(" {Expr ","}* ")" Trailing
  | Id >> [(] "(" {Expr ","}* ")" Trailing
  
  // args but no parens, and trailing.
  | noParens: Expr "." Id >> [:] ":" {Expr ","}+ Trailing  
  | noParensSelf: Id >> [:] ":" {Expr ","}+ Trailing

  // args but no parens, and no trailing.
  | noParensNoTrailing: Expr "." Id >> [:] ":" {Expr ","}+ ";"  
  | noParensSelfNoTrailing: Id >> [:] ":" {Expr ","}+ ";"
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
  = Stm+ // never empty, to have empty, use empty stat ;
  //| Stm* Expr // simplify just require ;
  ;

syntax Block
  = block0: "{" Body "}" // sugar
  | block: "(" { Id ","}* params ")" "{" Body body "}" 
  ;
  
  
syntax KeyVal
  = sym: Id ":" Expr
  | exp: Expr "=\>" Expr
  ;
  
syntax VId
  = @category="Variable" Id
  ;
  
syntax Expr
  = var: VId
  | field: FId
  | lit: Lit
  | block: Block
  
  | bracket brack: "(" Expr ")"
  | self: "self"
  
  // Construction
  | new: "new" CId >> [(] "(" {Expr ","}* ")"
  | new0: "new" CId // sugar
  | newAnonObj: "new" "{" Member* members "}"
  | newAnon0: "new" CId "{" Member* members "}"
  | newAnon: "new" CId >> [(] "(" {Expr ","}* ")" "{" Member* members "}"
  | newLit: "new" CId {Expr!notLit ","}+ // sugar
  
  // super sends
  | superSend: "super" "." DId  >> [(] "(" {Expr ","}* ")"
  | superSendNoArgs: "super" "." DId // sugar
  
  | getElt: Expr [\n\t\ ] !<< "[" Expr "]"
  > prefixPlus: "+" !>> [\n\t\ ]Expr
  | prefixMin: "-" !>> [\n\t\ ] Expr
  | prefixBang: "!" !>> [\n\t\ ] Expr
  | prefixTilde: "~" !>> [\n\t\ ] Expr

  // sends
  > sendNoArgs: Expr "." Id // sugar
  | send: Expr "." Id >> [(] "(" {Expr ","}* ")"
  | selfSend: Id >> [(] "(" {Expr ","}* ")" // sugar
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
  //> right infix: Expr (Id >> [:] ":" >> [\n\t\ ]) Expr
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
  
