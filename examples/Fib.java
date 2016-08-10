 
@SuppressWarnings({"unchecked"})
public interface Fib<$O extends Fib<$O>> 
   extends nomen.lang.Kernel<$O>, Bar<$O> {
  
  default $O main($O arg0) {
     return method_missing($str("main"), $array(arg0));
  }
  default $O to_string($O arg0) {
     return method_missing($str("to_string"), $array(arg0));
  }
  default $O dsl() {
     return method_missing($str("dsl"), $array());
  }
  default $O initialize($O arg0, $O arg1) {
     return method_missing($str("initialize"), $array(arg0, arg1));
  }
  default $O a($O arg0, $O arg1) {
     return method_missing($str("a"), $array(arg0, arg1));
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
    protected $O name;
    protected $O age;
    
  
    public Person() { 
      super(); 
      this.name = $nil();
      this.age = $nil();
      
    }
    @Override
  public $O initialize($O name, $O age) {
    $O $ret = $nil();
    $ret = Person.this.name = name;
    $ret = Person.this.age = age;
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
    $ret = (($O)Person.this).a($int(2), (($O)Person.this).a((($O)Person.this).b(($int(1))._plus($int(2)), (($O)Person.this).f($block(new nomen.lang.Kernel.Block<$O>() {
      @Override
      public $O call($O a) {
        $O $ret = $nil();
        $ret = ((($int(1))._plus($int(2)))._star($int(2)))._star(a);
        return $ret;
      }
    })))));
    return $ret;
  }
    @Override
  public $O to_string() {
    $O $ret = $nil();
    $ret = (((($str("Person("))._plus(Person.this.name))._plus($str(",")))._plus(Person.this.age))._plus($str(")"));
    return $ret;
  }
    
  }
  
  abstract class XX<$O extends Fib<$O>> extends nomen.lang.Kernel.Obj<$O> implements Fib<$O> {
    
  
    public XX() { 
      super(); 
      
    }
    
  }
  
  abstract class Main2<$O extends Fib<$O>> extends nomen.lang.Kernel.Obj<$O> implements Fib<$O> {
    
  
    public Main2() { 
      super(); 
      
    }
    @Override
  public $O to_string() {
    $O $ret = $nil();
    
    return $ret;
  }
    @Override
  public $O main($O args) {
    $O $ret = $nil();
    $O f = $ret = $new($Fib$Fact(), $obj1045 -> { $obj1045.initialize(); return $obj1045; });
    $ret = (($O)Main2.this).puts((f).fact($int(10)));
    $O x = $ret = $int(3);
    $O p = $ret = $new($Fib$Person(), $obj602 -> { $obj602.initialize($str("Tijs"), x); return $obj602; });
    $ret = (($O)Main2.this).puts(p);
    return $ret;
  }
    
  }
  
  
  
  
  
    
  $O $Fib$XX();
    
  $O $Fib$Bla();
    
  $O $Fib$Person();
    
  $O $Fib$Main2();
    
  $O $Fib$Fact();
    
  $O $Fib$Int();
    
  
}