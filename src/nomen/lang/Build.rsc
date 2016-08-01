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

void noLog(str x) {}

tuple[set[Message], Maybe[Built]] load(MId m, Maybe[start[Module]] maybePt = nothing(), list[loc] searchPath = [], bool clean = false, Log log = noLog) {
  int indent = 0;
  void ilog(str x) {
    msg = ( "" | it + " " | _ <- [0..indent] ) + x;
    log(msg);
  }

  set[Message] msgs = {};
  map[MId, tuple[bool, Maybe[Built]]] done = ();
  
  tuple[bool, Env] loadDeps(Env env, list[MId] path) {
    Env depEnv = env;
    bool change = false;
    indent += 2;
    for (<_, \import(str dep), loc def> <- env) {
      tuple[bool, Maybe[Built]] mb = loadRec(([MId]dep)[@\loc=def], path);
      change = change || mb[0];
      if (just(Built b) := mb[1]) {
        depEnv += b.env;
      }
      //depEnv += { *b.env | just(Built b) := mb };
    }
    indent -= 2;
    return <change, depEnv>;
  }
  
  Built buildPt(MId m, start[Module] pt, list[MId] path) {
    ilog("Desugaring, declaring and resolving <m>");
    pt = desugar(pt);
    Env env = declareModule(pt);        
    Refs refs = resolveModule(pt, loadDeps(env, [m, *path])[1]);
    Built built = <env, refs, pt>;
    return built;  
  }
   
  Maybe[Built] build(MId m, loc file, list[MId] path) {
    ilog("Parsing <file>");
    try {
      start[Module] pt = parse(#start[Module], file);
      return just(buildPt(m, pt, path));
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
      str cyclePath = "<m>-\> <intercalate("-\>", [ "<d>" | d <- path ])>"; 
      ilog("Cycle <cyclePath>");
      msgs += {error("Cyclic import <cyclePath>", cycle@\loc)};
      return <false, nothing()>;
    }
    
    if (m in done) {
      ilog("Already done <m>");
      return done[m];
    }
	
	  done[m] = <false, nothing()>; // Base result in case of error
	
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
        done[m] = <true, just(b)>;
      }
      else {
        done[m] = <true, nothing()>;
      }
      return done[m];
    }
	   
	  // env and pt are up to date, but refs might not, because of deps
    
    ilog("Built file for <m> is up to date");
    Built built = readBinaryValueFile(#Built, builtFile(file));
    <depChange, depEnv> = loadDeps(built.env, [m, *path]);
    if (depChange) {
      ilog("Change in dependencies of <m>");
      Refs refs = resolveModule(built.pt, depEnv);
      ilog("Updating built file for <m>");
      built.refs = refs;
      writeBinaryValueFile(builtFile(file), built);
    }
    else {
      ilog("No change in deps of <m>");
    }
    done[m] = <depChange, just(built)>;
    return done[m];
	}
  
  if (just(start[Module] pt) := maybePt) {
    ilog("Starting from parse tree.");
    Built built = buildPt(m, pt, []); 
    return <msgs, just(built)>;
  }
  Maybe[Built] mb = loadRec(m, [])[1];
  return <msgs, mb>;
}