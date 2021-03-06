 
@SuppressWarnings({"unchecked"})
public interface Fib<$O extends Fib<$O>> 
   extends nomen.lang.Kernel<$O>, Bar<$O> {
  
  default $O to_string($O arg0) {
     return method_missing($str("to_string"), $array(arg0));
  }
  default $O dsl() {
     return method_missing($str("dsl"), $array());
  }
  default $O initialize($O arg0, $O arg1) {
     return method_missing($str("initialize"), $array(arg0, arg1));
  }
  default $O main($O arg0) {
     return method_missing($str("main"), $array(arg0));
  }
  default $O call($O arg0) {
     return method_missing($str("call"), $array(arg0));
  }
  default $O a($O arg0, $O arg1) {
     return method_missing($str("a"), $array(arg0, arg1));
  }
  default $O initialize($O arg0) {
     return method_missing($str("initialize"), $array(arg0));
  }
  default $O b($O arg0, $O arg1) {
     return method_missing($str("b"), $array(arg0, arg1));
  }
  default $O _star($O arg0) {
     return method_missing($str("*"), $array(arg0));
  }
  default $O to_string() {
     return method_missing($str("to_string"), $array());
  }
  default $O _plus($O arg0) {
     return method_missing($str("+"), $array(arg0));
  }
  default $O fact($O arg0, $O arg1, $O arg2) {
     return method_missing($str("fact"), $array(arg0, arg1, arg2));
  }
  default $O initialize() {
     return method_missing($str("initialize"), $array());
  }
  default $O fact($O arg0) {
     return method_missing($str("fact"), $array(arg0));
  }
  default $O _minus($O arg0) {
     return method_missing($str("-"), $array(arg0));
  }
  default $O _leq($O arg0) {
     return method_missing($str("<="), $array(arg0));
  }
  default $O a($O arg0) {
     return method_missing($str("a"), $array(arg0));
  }
  default $O call() {
     return method_missing($str("call"), $array());
  }
  default $O f($O arg0) {
     return method_missing($str("f"), $array(arg0));
  }
  default $O puts($O arg0) {
     return method_missing($str("puts"), $array(arg0));
  }
  
  
  abstract class Int<$O extends Fib<$O>> extends nomen.lang.Kernel.Obj<$O> implements Fib<$O> {
    
    
  
    public Int() { 
      super(); 
      
    }
    
  }
  
  abstract class Bla<$O extends Fib<$O>> extends nomen.lang.Kernel.Obj<$O> implements Fib<$O> {
    
    
  
    public Bla() { 
      super(); 
      
    }
    @Override
  public $O fact($O x) {
    $O $ret = $nil();
    
    return $ret;
  }
    
  }
  
  abstract class Fact<$O extends Fib<$O>> extends Fib.Bla<$O> implements Fib<$O> {
    
    
  
    public Fact() { 
      super(); 
      
    }
    @Override
  public $O fact($O n) {
    $O $ret = $nil();
    if ($truth((n)._leq($int(1)))) {
      $ret = $int(1);
    }
    else {
      $ret = (n)._star((($O)Fact.this).fact((n)._minus($int(1))));
    }
    return $ret;
  }
    @Override
  public $O to_string($O x) {
    $O $ret = $nil();
    
    return $ret;
  }
    
  }
  
  abstract class Person<$O extends Fib<$O>> extends nomen.lang.Kernel.Obj<$O> implements Fib<$O> {
    protected $O _self;
    protected $O _age;
    protected $O _name;
    
    
  
    public Person() { 
      super(); 
      this._self = $nil();
      this._age = $nil();
      this._name = $nil();
      
    }
    @Override
  public $O initialize($O name, $O age) {
    $O $ret = $nil();
    $ret = Person.this._name = name;
    $ret = Person.this._age = age;
    return $ret;
  }
    @Override
  public $O fact($O n, $O a, $O b) {
    $O $ret = $nil();
    
    return $ret;
  }
    @Override
  public $O dsl() {
    $O $ret = $nil();
    $ret = (($O)Person.this).a($int(2), (($O)Person.this).a((($O)Person.this).b(($int(1))._plus($int(2)), (($O)Person.this).f($new($Fib$Anon_examples_Fib_nomen_369(), $obj369 -> { $obj369.initialize(($O)Person.this); return $obj369; })))));
    return $ret;
  }
    @Override
  public $O to_string() {
    $O $ret = $nil();
    $ret = (((($str("Person("))._plus(Person.this._name))._plus($str(",")))._plus(Person.this._age))._plus($str(")"));
    return $ret;
  }
    
  }
  
  abstract class XX<$O extends Fib<$O>> extends nomen.lang.Kernel.Obj<$O> implements Fib<$O> {
    
    
  
    public XX() { 
      super(); 
      
    }
    
  }
  
  abstract class Main<$O extends Fib<$O>> extends nomen.lang.Kernel.Obj<$O> implements Fib<$O> {
    protected $O _self;
    
    
  
    public Main() { 
      super(); 
      this._self = $nil();
      
    }
    @Override
  public $O to_string() {
    $O $ret = $nil();
    
    return $ret;
  }
    @Override
  public $O main($O args) {
    $O $ret = $nil();
    $O f = $ret = $new($Fib$Fact(), $obj1114 -> { $obj1114.initialize(); return $obj1114; });
    $ret = (($O)Main.this).puts((f).fact($int(10)));
    $O[] x = $box($ret = $int(3));
    $O p = $ret = $new($Fib$Person(), $obj601 -> { $obj601.initialize($str("Tijs"), x[0]); return $obj601; });
    $O aBlock = $ret = $new($Fib$Anon_examples_Fib_nomen_641(), $obj641 -> { ((Anon_examples_Fib_nomen_641<$O>)$obj641).x = x; $obj641.initialize(($O)Main.this); return $obj641; });
    $ret = (($O)Main.this).puts(p);
    return $ret;
  }
    
  }
  
  
  
  abstract class Anon_examples_Fib_nomen_369<$O extends Fib<$O>> extends nomen.lang.Kernel.Block<$O> implements Fib<$O> {
    protected $O _self;
    
    
  
    public Anon_examples_Fib_nomen_369() { 
      super(); 
      this._self = $nil();
      
    }
    @Override
  public $O initialize($O myself) {
    $O $ret = $nil();
    $ret = Anon_examples_Fib_nomen_369.this._self = myself;
    return $ret;
  }
    @Override
  public $O call($O a) {
    $O $ret = $nil();
    $ret = ((($int(1))._plus($int(2)))._star($int(2)))._star(a);
    return $ret;
  }
    
  }
  
  abstract class Anon_examples_Fib_nomen_641<$O extends Fib<$O>> extends nomen.lang.Kernel.Block<$O> implements Fib<$O> {
    protected $O _self;
    
    public $O[] x;
    
  
    public Anon_examples_Fib_nomen_641() { 
      super(); 
      this._self = $nil();
      
    }
    @Override
  public $O initialize($O myself) {
    $O $ret = $nil();
    $ret = Anon_examples_Fib_nomen_641.this._self = myself;
    return $ret;
  }
    @Override
  public $O call() {
    $O $ret = $nil();
    $ret = (Anon_examples_Fib_nomen_641.this._self).puts(($str("Hello world!"))._plus(x[0]));
    return $ret;
  }
    
  }
  
  
  
    interface $Self extends Fib<$Self> { }
    
    
    default $O $Fib$Anon_examples_Fib_nomen_641() {
      return ($O)new $Fib$Anon_examples_Fib_nomen_641();
    }
    
    @Override
    default $O $nomen$lang$Kernel$Int() {
      return ($O)new $nomen$lang$Kernel$Int();
    }
    
    
    default $O $Fib$Main() {
      return ($O)new $Fib$Main();
    }
    
    @Override
    default $O $nomen$lang$Kernel$Nil() {
      return ($O)new $nomen$lang$Kernel$Nil();
    }
    
    @Override
    default $O $nomen$lang$Kernel$Array() {
      return ($O)new $nomen$lang$Kernel$Array();
    }
    
    @Override
    default $O $nomen$lang$Kernel$Block() {
      return ($O)new $nomen$lang$Kernel$Block();
    }
    
    @Override
    default $O $nomen$lang$Kernel$Bool() {
      return ($O)new $nomen$lang$Kernel$Bool();
    }
    
    
    default $O $Fib$XX() {
      return ($O)new $Fib$XX();
    }
    
    
    default $O $Fib$Bla() {
      return ($O)new $Fib$Bla();
    }
    
    
    default $O $Fib$Person() {
      return ($O)new $Fib$Person();
    }
    
    @Override
    default $O $nomen$lang$Kernel$Iter() {
      return ($O)new $nomen$lang$Kernel$Iter();
    }
    
    @Override
    default $O $nomen$lang$Kernel$Nihil() {
      return ($O)new $nomen$lang$Kernel$Nihil();
    }
    
    
    default $O $Fib$Fact() {
      return ($O)new $Fib$Fact();
    }
    
    @Override
    default $O $nomen$lang$Kernel$Obj() {
      return ($O)new $nomen$lang$Kernel$Obj();
    }
    
    @Override
    default $O $nomen$lang$Kernel$Str() {
      return ($O)new $nomen$lang$Kernel$Str();
    }
    
    
    default $O $Fib$Int() {
      return ($O)new $Fib$Int();
    }
    
    @Override
    default $O $Bar$A() {
      return ($O)new $Bar$A();
    }
    
    
    default $O $Fib$Anon_examples_Fib_nomen_369() {
      return ($O)new $Fib$Anon_examples_Fib_nomen_369();
    }
     
    
    class $Fib$Anon_examples_Fib_nomen_641 extends Fib.Anon_examples_Fib_nomen_641<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Int extends nomen.lang.Kernel.Int<$Self> implements $Self { } 
    
    class $Fib$Main extends Fib.Main<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Nil extends nomen.lang.Kernel.Nil<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Array extends nomen.lang.Kernel.Array<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Block extends nomen.lang.Kernel.Block<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Bool extends nomen.lang.Kernel.Bool<$Self> implements $Self { } 
    
    class $Fib$XX extends Fib.XX<$Self> implements $Self { } 
    
    class $Fib$Bla extends Fib.Bla<$Self> implements $Self { } 
    
    class $Fib$Person extends Fib.Person<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Iter extends nomen.lang.Kernel.Iter<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Nihil extends nomen.lang.Kernel.Nihil<$Self> implements $Self { } 
    
    class $Fib$Fact extends Fib.Fact<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Obj extends nomen.lang.Kernel.Obj<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Str extends nomen.lang.Kernel.Str<$Self> implements $Self { } 
    
    class $Fib$Int extends Fib.Int<$Self> implements $Self { } 
    
    class $Bar$A extends Bar.A<$Self> implements $Self { } 
    
    class $Fib$Anon_examples_Fib_nomen_369 extends Fib.Anon_examples_Fib_nomen_369<$Self> implements $Self { } 
    
    static void main(String[] args) {
      Main<$Self> main = new Main<$Self>() {};
      main.main(main.$args(args));
    }
  
}