module nomen::lang::IDE

import ParseTree;
import nomen::lang::Nomen;
import util::IDE;
import nomen::lang::Resolve;
import nomen::lang::Check;
import nomen::lang::Desugar;
import nomen::lang::Outline;
import nomen::lang::Build;
import Message;
import IO;
import util::Maybe;

anno rel[loc, loc, str] Tree@hyperlinks; 

void setupNomenIDE() {
  registerLanguage("Nomen", "nomen", start[Module](str src, loc org) {
    return parse(#start[Module], src, org);
  });
  
  registerContributions("Nomen", {
    annotator(start[Module](Tree pt) {
        if (start[Module] m := pt) {
          <msgs, maybeBuilt> = load(m.top.name, maybePt = just(m), searchPath = [
            |project://Nomen/examples|, |project://Nomen/src|
          ], log = println);
          iprintln(msgs);
          links = {};
          if (just(Built built) := maybeBuilt) {
            iprintln(built.classes);
            links = built.refs<1,2,3>;
          }
          return m[@hyperlinks=links]; //[@messages=msgs];
        }
        return pt;
      }),
     outliner(outlineModule)
   }
  );

  registerTestCheck(checkModules);  
}


