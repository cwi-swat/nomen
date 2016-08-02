package nomen.lang;

import java.util.Iterator;


/*
 * - mangle builtin method names (toString, hashcode, wait, String (everything java.lang) etc.)
 *   (use start with _ as this kind of mangling, $ for internal stuff.
 * - how to deal with closures
 * - Q: self sends can be on this (because the names will always be in payload), 
 *   but this cannot be returned or given as argument (because it's not an E).
 * Todo
 * - Method + tear-offs
 * - symbols (:x) (interned)
 * - make sure all basic Java classes here use qualified names (e.g., String)
 * - ranges, map notation
 * - capturing of fields in closures? and this
 *   --> Array.this.$self; qualify with outer class
 * - all constructors nillary + initialize in payload (always call super constructor super())
 * - meta class: Class.new is nicer it will call initialize, Class then also become values.
 *   --> class Foo -> class Foo { ... } with static method returning $$create(new Class<$E>(Foo.class));
 * 
 * Checks
 * 
 * Module payload: is set of selectors and set of classes.
 * 
 * Errors
 * - import not found
 * - filename does not correspond to module name -> quick fix
 * - cyclic import
 * - ambiguous class ref -> quick fix, qualify name
 * - class not in scope (both after new and in extends)
 * - cyclic inheritance
 * - selector is not in scope (do we separate uses/defs?)
 * - undefined local variable (assignment introduces one; or should we have "var"?)
 * - |, &, ~, <<, >>, operators.
 * 
 * Warnings
 * - duplicate import
 * - importing kernel
 * [- selector has no definition in scope]
 * [- field is never assigned (?)]
 * 
 * Extensions
 * - debug info
 * - profiling
 * - new syntactic forms
 * - new data literals (ranges)
 * - asciidoc + code in doc
 * - live text (?) probes
 * - recaf liberation?
 * - traits (-> interfaces with defaults, needs super disamb)
 * - monkey patching (virtual classes)
 * - macros?
 * - infix alphanumer e.g., x or: y
 * 
 * def exp 
 *     primary 
 *   | exp ~ "+" ~ exp then: (x, y) { ... }
 *   | exp ~ "*" ~ exp then: 
 * 
 */

public interface Kernel<$E extends Kernel<$E>>  {

  default $E $nomen$lang$Kernel$Int() {
    return ($E)new Int();
  } 
  
  default $E $nomen$lang$Kernel$Iter() {
    return ($E)new Iter();
  } 
  
  default $E $nomen$lang$Kernel$Block() {
    return ($E)new Block();
  } 
  
  default $E $nomen$lang$Kernel$Nil() {
    return ($E)new Nil();
  } 
  
  default $E $nomen$lang$Kernel$Str() {
    return ($E)new Str();
  } 
  
  default $E $nomen$lang$Kernel$Bool() {
    return ($E)new Bool();
  } 
  
  default $E $nomen$lang$Kernel$Array() {
    return ($E)new Array();
  } 
  
  default $E $nomen$lang$Kernel$Obj() {
    return ($E)new Obj();
  } 
	
	default $E $false() {
		return $bool(false);
	}

	default $E $true() {
		return $bool(true);
	}

	default $E $nil() {
		return $nomen$lang$Kernel$Nil();
	}
	
	/*
	 * fields: for all @x define a field protected E x;
	 * @x reference -> this.x;
	 * 
	 * constructors
	 * for all new C(...) add initialize(...) to payload.
	 * 
	 * if ($E) -> if ($truthy($E))
	 */
	
	class $Exception extends RuntimeException {
		private static final long serialVersionUID = 1L;
		// try catch (X e) {... } ==> try catch ($Exception e_) { if (e_.object.internal().getClass() == X.class) { E e = ($E)e_.object; ... }
		private final Object object;

		public $Exception(Object e) {
			this.object = e;
		}
		
		public boolean $catch(java.lang.Class<?> cls) {
			// TODO: need to get $iternal?
			return cls.isInstance(object);
		}
	}
	
	default $E $block(Block<$E> b) {
		// TODO: needs to be virtualized
		return null;
	}

	default $E $int(Integer x) {
		Int<$E> n = ((Int<$E>)$nomen$lang$Kernel$Int());
		n.integer = x;
		return ($E) n;
	}

	default $E $str(String x) {
		Str<$E> s = (Str<$E>) $nomen$lang$Kernel$Str();
		s.string = x;
		return ($E)s;
	}
	
	default $E $args(String[] args) {
		Object[] strs = java.util.Arrays.stream(args).map(x -> $str(x)).toArray();
		return $array(strs);
	}

	default $E $bool(boolean x) {
		$E b = $nomen$lang$Kernel$Bool();
		((Bool<$E>)b).bool = x;
		return b;
	}
	
	default $E $array(Object ...array) {
		Array<$E> a = (Array<$E>)$nomen$lang$Kernel$Array();
		a.array = array;
		return ($E)a;
	}

	default boolean $truth($E x) {
		if (x instanceof Nil) {
			return false;
		}
		if (x instanceof Bool && !((Bool<$E>)x).bool) {
			return false;
		}
		return true;
	}
	
	default java.lang.Iterable<$E> $iter($E obj) {
		$E iter = obj.iter();
		return new java.lang.Iterable<$E>() {
			@Override
			public Iterator<$E> iterator() {
				return new Iterator<$E>() {

					@Override
					public boolean hasNext() {
						System.out.println("obj = " + obj);
						return $truth(iter.has_next());
					}

					@Override
					public $E next() {
						return iter.next();
					}
				};
			}
		};
	}

	default void $throw($E e) {
		throw new $Exception(e);
	}

	default boolean $is(java.lang.Class<?> x) {
		return x.isInstance(this);
	}

	default $E method_missing($E sym, $E args) {
		throw new RuntimeException("noSuchMethod " + sym + " on " + this + " with arguments " + args);
	}

	default $E _equals($E other) {
		return method_missing($str("=="), $array(other));
	}

	default $E _leq($E other) {
		return method_missing($str("<="), $array(other));
	}

	default $E _neq($E other) {
		return method_missing($str("!="), $array(other));
	}

	default $E to_string() {
		return method_missing($str("to_string"), $array());
	}

	default $E concat($E other) {
		return method_missing($str("concat"), $array(other));
	}

	default $E or($E other) {
		return method_missing($str("or"), $array(other));
	}

	default $E and($E other) {
		return method_missing($str("and"), $array(other));
	}

	default $E _plus($E other) {
		return method_missing($str("+"), $array(other));
	}

	default $E _minus($E other) {
		return method_missing($str("-"), $array(other));
	}

	default $E _star($E other) {
		return method_missing($str("*"), $array(other));
	}

	default $E _slash($E other) {
		return method_missing($str("/"), $array(other));
	}

	default $E call() {
		return method_missing($str("call"), $array());
	}
	
	default $E call($E arg1) {
		return method_missing($str("call"), $array(arg1));
	}

	default $E call($E arg1, $E arg2) {
		return method_missing($str("call"), $array(arg1, arg2));
	}

	default $E call($E arg1, $E arg2, $E arg3) {
		return method_missing($str("call"), $array(arg1, arg2, arg3));
	}
	// ... etc.

	default $E method($E sym) {
		return null;
	}

	default $E is_a($E klass) {
		return method_missing($str("is_a"), $array(klass));
	}

	default $E puts($E obj) {
		return method_missing($str("puts"), $array(obj));
	}
		
	
	default $E iter() {
		return method_missing($str("iter"), $array());
	}
	
	default $E has_next() {
		return method_missing($str("has_next"), $array());
	}

	default $E next() {
		return method_missing($str("next"), $array());
	}

	default $E initialize() {
		return method_missing($str("initialize"), $array());
	}

	default $E initialize($E arg1) {
		return method_missing($str("initialize"), $array(arg1));
	}

	default $E initialize($E arg1, $E arg2) {
		return method_missing($str("initialize"), $array(arg1, arg2));
	}

	default $E initialize($E arg1, $E arg2, $E arg3) {
		return method_missing($str("initialize"), $array(arg1, arg2, arg3));
	}


	default $E $new($E obj, java.util.function.Function<$E,$E> init) {
		return init.apply(obj);
	}
	
	// TODO: make interface to allow interop with ordinary Java classes.
	class Obj<$E extends Kernel<$E>> implements Kernel<$E> {
		@Override
		public $E initialize() {
			return ($E) this;
		}
		
		@Override
		public $E is_a($E klass) {
			throw new RuntimeException("TODO");
		}
		
		
		@Override
		public $E to_string() {
			// NB: this requires $Class to have to_string, otherwise we loop.
			return $str(this.getClass() + "#" + System.identityHashCode(this));
		}
		
		// To interface with java println.
		@Override
		public String toString() {
			// todo: error handling.
			return ((Str<$E>)to_string()).string;
		}
		
		@Override
		public $E puts($E obj) {
			System.out.println(obj);
			return $nil();
		}
		
		
	}

	class Block<$E extends Kernel<$E>> extends Obj<$E> {
		// to be overridden in anonymous subclasses.
		
		@Override
		public $E call() {
			return call($nil());
		}
		
		@Override
		public $E call($E arg1) {
			return call(arg1, $nil());
		}
		
		@Override
		public $E call($E arg1, $E arg2) {
			return call(arg1, arg2, $nil());
		}
		
		@Override
		public $E call($E arg1, $E arg2, $E arg3) {
			throw new RuntimeException("too many arguments");
		}
		
	}
	
	class Exc<$E extends Kernel<$E>> extends Obj<$E> {
		
	}
	
	class Nil<$E extends Kernel<$E>> extends Obj<$E> {
		public $E to_string() {
			return $str("nil");
		}
	}
	
	class Array<$E extends Kernel<$E>> extends Obj<$E> {
		private Object[] array;

		@Override
		public $E to_string() {
			String s = "[";
			for (int i = 0; i < array.length; i++) {
				s += array[i].toString();
				if (i < array.length - 1) {
					s += ", ";
				}
			}
			s += "]";
			return $str(s);
		}
		
		@Override
		public $E iter() {
			int i[] = new int[]{0};
			$E hasNext = $block(new Block<$E>() {
				@Override
				public $E call() {
					return i[0] < array.length ? $true() : $false();
				}
			});
			$E next = $block(new Block<$E>() {
				@SuppressWarnings("unchecked")
				@Override
				public $E call() {
					i[0]++;
					return ($E) array[i[0] - 1];
				}
			});
			$E x = Iter();
			x.initialize(hasNext, next);
			System.out.println("x = " + x);
			return x;
		}
	}
	
	default $E Iter() {
		return ($E)new Iter<$E>();
	}
	
	class Iter<$E extends Kernel<$E>> extends Obj<$E> {
		// todo: make all constructors nillary, and add initialize(...)
		
		protected $E has_next;
		protected $E next;

		public Iter() {
			this.has_next = $nil();
			this.next = $nil();
		}
		
		@Override
		public $E initialize($E has_next, $E next) {
			this.has_next = has_next;
			this.next = next;
			return $nil();
		}

		@Override
		public $E has_next() {
			return has_next.call();
		}
		
		@Override
		public $E next() {
			return next.call();
		}
		
	}
	
	class Class<$E extends Kernel<$E>> extends Obj<$E> {
		private final java.lang.Class<?> klass;
		
		public Class(java.lang.Class<?> klass) {
			this.klass = klass;
		}
		
		@Override
		public $E to_string() {
			return $str(klass.getSimpleName());
		}
		
	}

	class Int<$E extends Kernel<$E>> extends Obj<$E> {
		Integer integer;
		
		@Override
		public $E _equals($E other) {
			return $bool(toi(other).equals(this.integer));
		}
		
		@Override
		public $E _leq($E other) {
			return $bool(this.integer <= toi(other));
		}
		
		@Override
		public $E to_string() {
			return $str(integer.toString());
		}
		
		@Override
		public $E _plus($E other) {
			return $int(integer + toi(other));
		}

		@Override
		public $E _minus($E other) {
			return $int(integer - toi(other));
		}
		
		@Override
		public $E _star($E other) {
			return $int(integer * toi(other));
		}
		
		@Override
		public $E _slash($E other) {
			return $int(integer / toi(other));
		}

		
		private Integer toi($E e) {
			// todo: exceptions
			return ((Int<$E>)e).integer;
		}
		
	}
	class Bool<$E extends Kernel<$E>> extends Obj<$E> {
		private Boolean bool;

		@Override
		public $E _equals($E other) {
			System.out.println("Comparing bools: " + this + " == " + other);
			if (!(other instanceof Bool)) {
				return $false();
			}
			return $bool(this.bool == tob(other));
		}
		
		@Override
		public $E to_string() {
			return $str(bool.toString());
		}
		
		@Override
		public $E or($E other) {
			return bool ? ($E) this : other;
		}
		
		@Override
		public $E and($E other) {
			return !bool ? ($E) this : other;
		}
		
		private boolean tob($E other) {
			return ((Bool<$E>)other).bool;
		}
	}
		
	class Str<$E extends Kernel<$E>> extends Obj<$E> {
		String string = "";

		@Override
		public $E _equals($E other) {
			if (!other.$is(Str.class)) {
				return $bool(false);
			}
			return $bool(tos(other).equals(this.string));
		}
		
		private String tos($E e) {
			return ((Str<$E>)e).string;
		}
		
		@Override
		public $E to_string() {
			return ($E) this;
		}
		
		@Override
		public $E concat($E other) {
			return $str(string + other.toString());
		}
		
		@Override
		public $E _plus($E other) {
			return concat(other);
		}
	}
	
}
