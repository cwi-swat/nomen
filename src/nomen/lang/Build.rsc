module nomen::lang::Build

import nomen::lang::Nomen;
import nomen::lang::Declare;
import nomen::lang::Resolve;
import nomen::lang::Desugar;
import nomen::lang::Compile;
import Set;
import ValueIO;
import IO;
import Message;
import util::Maybe;
import ParseTree;
import util::FileSystem;
import String;

// TODO: maybe omit parse tree
alias Built = tuple[Env env, Refs refs, Classes classes, start[Module] pt];

set[loc] findModule(MId m, list[loc] searchPath)
  = { *find(p, bool(loc l) { return endsWith(l.path, "/<m>.nomen"); }) | p <- searchPath }; 

alias Log = void(str);

void noLog(str x) {}

loc builtFile(loc src) = src[extension="built"];
loc javaFile(loc src) = src[extension="java"];
  
// TODO: add boolean param compile=false to not compile when
// doing annotation
// TODO: add checking, don't write Java if errors in module
// or dependencies.
tuple[set[Message], Maybe[Built]] load(MId m, Maybe[start[Module]] maybePt = nothing(), 
                       list[loc] searchPath = [], bool clean = false, bool compile = false,
                       Log log = noLog) {
  int indent = 0;
  void ilog(str x) {
    msg = ( "" | it + "  " | _ <- [0..indent] ) + x;
    log(msg);
  }

  set[Message] msgs = {};
  map[MId, tuple[bool, Maybe[Built]]] done = ();
  
  tuple[bool, Env, Classes] loadDeps(MId m, Env env, list[MId] path) {
    Env depEnv = env;
    bool change = false;
    indent += 1;
    Classes classes = { <"<m>", c> | <_, class(str c), _> <- env };
    imports = [ ([MId]dep)[@\loc=def] | <_, \import(str dep), loc def> <- env ];
    for (MId dep <- imports) {
      tuple[bool, Maybe[Built]] mb = loadRec(dep, path);
      change = change || mb[0];
      if (just(Built b) := mb[1]) {
        depEnv += b.env;
        classes += b.classes;
      }
    }
    indent -= 1;
    return <change, depEnv, classes>;
  }
  
  Built buildPt(MId m, start[Module] pt, list[MId] path) {
    ilog("Desugaring, declaring and resolving <m>");
    pt = desugar(pt);
    Env env = declareModule(pt);  
    <_, depEnv, classes> = loadDeps(m, env, [m, *path]);      
    Refs refs = resolveModule(pt, depEnv);
    Built built = <env, refs, classes, pt>;
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
  
  void save(loc file, Built b) {
    writeBinaryValueFile(builtFile(file), b);
    if (!endsWith(file.path, "nomen/lang/Kernel.nomen")) {
      // TODO: need systematic way of dealing with modules implemented in Java. 
      writeFile(javaFile(file), compileModule(b.pt, b.env, b.refs, b.classes));
    }
  }
  
  bool needsBuild(loc src) 
    = !exists(builtFile(src)) 
    || (lastModified(builtFile(src)) <= lastModified(src))
    || clean;
  
  tuple[bool, Maybe[Built]] loadRec(MId m, list[MId] path) {
    ilog("Loading <m>...");
    
    if (MId cycle <- path, cycle == m) {
      str cyclePath = "<m>-\><intercalate("-\>", [ "<d>" | d <- path ])>"; 
      ilog("Cycle <cyclePath>");
      msgs += {error("Cyclic import <cyclePath>", cycle@\loc)};
      return <false, nothing()>;
    }
    
    if (m in done) {
      ilog("Already done <m>");
      return done[m];
    }
	
	  done[m] = <false, nothing()>; // Base result in case of error
	
	  set[loc] files = findModule(m, searchPath);
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
        save(file, b);
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
    <depChange, depEnv, classes> = loadDeps(m, built.env, [m, *path]);
    if (depChange) {
      ilog("Change in dependencies of <m>");
      Refs refs = resolveModule(built.pt, depEnv);
      ilog("Updating built file for <m>");
      built.refs = refs;
      built.classes = classes;
      save(file, built);
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
    ilog("Saving built file for <m>");
    // TODO: really do this here?
    writeBinaryValueFile(builtFile(pt@\loc), built);
    return <msgs, just(built)>;
  }
  Maybe[Built] mb = loadRec(m, [])[1];
  return <msgs, mb>;
}