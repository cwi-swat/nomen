module nomen::lang::Outline

import ParseTree;
import nomen::lang::Nomen;
import util::IDE;
import List;
import Map;

node outlineModule(start[Module] m) {
  classes = ();
  
  node current = ""();
  top-down visit (m) {
    case (Decl)`class <CId c> <Member* _>`: {
      current = "<c>"()[@label="<c>"][@\loc=c@\loc];
      classes[current] = [];  
    }

    case (Decl)`class <CId c>: <CId d>  <Member* _>`: {
      current = "<c>"()[@label="<c>: <d>"][@\loc=c@\loc];
      classes[current] = [];  
    }
    
    case (Member)`def <DId d>(<{Id ","}* fs>): <Body b>`:
      classes[current] += ["def"()[@label="<d>(<fs>)"][@\loc=d@\loc]];

    case (Member)`def <DId d>: <Body b>`:
      classes[current] += ["def"()[@label="<d>"][@\loc=d@\loc]];
  } 

  return "outline"(
     [ "class"(classes[c])[@label=c@label][@\loc=c@\loc]  | c <- classes ]
  );

}