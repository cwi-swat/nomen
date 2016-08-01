module nomen::lang::IDE

import ParseTree;
import nomen::lang::Nomen;
import util::IDE;
import nomen::lang::Resolve;
import nomen::lang::Check;
import nomen::lang::Desugar;
import nomen::lang::Outline;
import Message;
import IO;

anno rel[loc, loc, str] Tree@hyperlinks; 

void setupNomenIDE() {
  registerLanguage("Nomen", "nomen", start[Module](str src, loc org) {
    return parse(#start[Module], src, org);
  });
  
  registerContributions("nomen", {
    annotator(start[Module](Tree pt) {
        if (start[Module] m := pt) {
          md = desugar(m);
          env = declareModule2(md, []);
          refs = resolveModule(md, env);
          msgs = checkModule(md, refs);
          return m[@hyperlinks=refs<1,2,3>][@messages=msgs];
        }
        return pt;
      }),
     outliner(outlineModule)
   }
  );

  registerTestCheck(checkModules);  
}


