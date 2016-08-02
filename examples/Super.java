 
@SuppressWarnings({"unchecked", "unused"})
public interface Super<$O extends Super<$O>>
   
   extends nomen.lang.Kernel<$O>
   {
  
  default $O puts($O arg0) {
     return method_missing($str("puts"), $array(arg0));
  }
  default $O f() {
     return method_missing($str("f"), $array());
  }
  default $O main($O arg0) {
     return method_missing($str("main"), $array(arg0));
  }
  
  
  default $O $Super$Main() {
    return ($O)new $Super$Main();
  } 
  @Override
  default $O $nomen$lang$Kernel$Int() {
    return ($O)new $nomen$lang$Kernel$Int();
  } 
  @Override
  default $O $nomen$lang$Kernel$Iter() {
    return ($O)new $nomen$lang$Kernel$Iter();
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
  default $O $nomen$lang$Kernel$Str() {
    return ($O)new $nomen$lang$Kernel$Str();
  } 
  @Override
  default $O $nomen$lang$Kernel$Bool() {
    return ($O)new $nomen$lang$Kernel$Bool();
  } 
  
  default $O $Super$Bar() {
    return ($O)new $Super$Bar();
  } 
  
  default $O $Super$Foo() {
    return ($O)new $Super$Foo();
  } 
  @Override
  default $O $nomen$lang$Kernel$Obj() {
    return ($O)new $nomen$lang$Kernel$Obj();
  } 
  

  interface $Self extends Super<$Self> { }

  
  class $Super$Main extends Super.Main<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Int extends nomen.lang.Kernel.Int<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Iter extends nomen.lang.Kernel.Iter<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Nil extends nomen.lang.Kernel.Nil<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Array extends nomen.lang.Kernel.Array<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Block extends nomen.lang.Kernel.Block<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Str extends nomen.lang.Kernel.Str<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Bool extends nomen.lang.Kernel.Bool<$Self> implements $Self { } 
  
  class $Super$Bar extends Super.Bar<$Self> implements $Self { } 
  
  class $Super$Foo extends Super.Foo<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Obj extends nomen.lang.Kernel.Obj<$Self> implements $Self { } 
  

  
  class Foo<$O extends Super<$O>> extends nomen.lang.Kernel.Obj<$O> implements Super<$O> {
    
  
    public Foo() { 
      super(); 
      
    }
    @Override
  public $O f() {
    $O $ret = $nil();
    $ret = (($O)Foo.this).puts($str("Foo"));
    return $ret;
  }
    
  }
  
  class Bar<$O extends Super<$O>> extends Super.Foo<$O> implements Super<$O> {
    
  
    public Bar() { 
      super(); 
      
    }
    @Override
  public $O f() {
    $O $ret = $nil();
    $ret = super.f();
    return $ret;
  }
    
  }
  
  class Main<$O extends Super<$O>> extends nomen.lang.Kernel.Obj<$O> implements Super<$O> {
    
  
    public Main() { 
      super(); 
      
    }
    @Override
  public $O main($O args) {
    $O $ret = $nil();
    $O bar = $new($Super$Bar(), $obj1047 -> { $obj1047.initialize(); return $obj1047; });
    $ret = (bar).f();
    return $ret;
  }
    
  }
  
  
  
  static void main(String[] args) {
    Main<$Self> main = new Main<$Self>();
    main.main(main.$args(args));
  }
  
}