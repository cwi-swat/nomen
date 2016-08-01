module nomen::lang::Build

import nomen::lang::Nomen;
import nomen::lang::Declare;
import nomen::lang::Resolve;
import nomen::lang::Desugar;
import Set;
import ValueIO;
import IO;
import Message;
import util::Maybe;
import ParseTree;

alias Built = tuple[Env env, Refs refs, start[Module] pt];

set[loc] findModule(MId m, list[loc] searchPath)
  = { l | exists(l) }
  when loc l := |project://Nomen/examples/<"<m>">.nomen|;


alias Log = void(str);
alias Msg = void(Message);

void noLog(str x) {}
void noMessages(Message m) {}

tuple[set[Message], Maybe[Built]] load(MId m, list[loc] searchPath, bool clean = false, Log log = noLog, Msg msg = noMessages) {
  set[Message] msgs = {};
  map[MId, Maybe[Built]] done = ();
  int indent = 0;
  
  void ilog(str x) {
    msg = ( "" | it + " " | _ <- [0..indent] ) + x;
    log(msg);
  }
  
  tuple[bool, Env] loadDeps(Env env, list[MId] path) {
    depEnv = env;
    change = false;
    indent += 2;
    for (<_, \import(str dep), _> <- env) {
      <c, mb> = loadRec([MId]dep, path);
      change = change || c;
      depEnv += { *b.env | just(Built b) := mb };
    }
    indent -= 2;
    return <change, depEnv>;
  }
   
  Maybe[Built] build(MId m, loc file, list[MId] path) {
    ilog("Building <file>");
    try {
      pt = desugar(parse(#start[Module], file));
  		env = declareModule(pt);        
      refs = resolveModule(pt, loadDeps(env, [m, *path])[1]);
      return just(<env, refs, pt>);
    }
    catch ParseError(loc x): {
      ilog("Parse error for <m> at <x>");
      msgs += {error("Parse error", x)};
      return nothing();
    } 
  }
  
  loc builtFile(loc src) = src[extension="built"];
  
  bool needsBuild(loc src) 
    = !exists(builtFile(src)) 
    || (lastModified(builtFile(src)) <= lastModified(src))
    || clean;
  
  tuple[bool, Maybe[Built]] loadRec(MId m, list[MId] path) {
    ilog("Loading <m>...");
    
    if (MId cycle <- path, cycle == m) {
      ilog("Cycle <m>-\>" + intercalate("-\>", [ "<d>" | d <- path ]));
      msgs += {error("Cyclic import <m>", cycle@\loc)};
      return <false, nothing()>;
    }
    
    if (m in done) {
      ilog("Already done <m>");
      return <false, done[m]>;
    }
	
	  done[m] = nothing(); // to stop at cycles
	
	  files = findModule(m, searchPath);
	  if (files == {}) {
	    ilog("No file for module <m>");
	    msgs += {error("Could not find module in search path", m@\loc)};
	    return <false, nothing()>; 
	  }
	  
	  if (size(files) > 1) {
	    ilog("Multiple files for module <m>");
	    msgs += {warning("Found multiple files for module", m@\loc)};
	  }

    loc file = getOneFrom(files);	  
    if (needsBuild(file)) {
      ilog("Module <m> needs a build");
      if (just(Built b) := build(m, file, path)) {
        ilog("Successful build of <m>, saving built file");
        writeBinaryValueFile(builtFile(file), b);
        done[m] = just(b);
      }
      return <true, done[m]>;
    }
	   
	  ilog("Built file for <m> is up to date");
    // env and pt are up to date, but refs might not, because of deps
    <env, refs, pt> = readBinaryValueFile(#Built, builtFile(file));
    <depChange, depEnv> = loadDeps(env, [m, *path]);
    if (depChange) {
      ilog("Change in dependencies of <m>");
      refs = resolveModule(pt, depEnv);
      ilog("Updating built file for <m>");
      writeBinaryValueFile(builtFile(file), <env, refs, pt>);
    }
    else {
      ilog("No change in deps of <m>");
    }
    done[m] = just(<env, refs, pt>);
    return <depChange, done[m]>;
	}
  
  return <msgs, loadRec(m, [])[1]>;
}