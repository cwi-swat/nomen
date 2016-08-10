 
@SuppressWarnings({"unchecked"})
public interface Foo<$O extends Foo<$O>> 
   extends Bar<$O>, Fib<$O>, nomen.lang.Kernel<$O> {
  
  default $O _star($O arg0) {
     return method_missing($str("*"), $array(arg0));
  }
  default $O initialize() {
     return method_missing($str("initialize"), $array());
  }
  default $O fact($O arg0) {
     return method_missing($str("fact"), $array(arg0));
  }
  default $O _leq($O arg0) {
     return method_missing($str("<="), $array(arg0));
  }
  default $O initialize($O arg0, $O arg1, $O arg2, $O arg3) {
     return method_missing($str("initialize"), $array(arg0, arg1, arg2, arg3));
  }
  default $O puts($O arg0) {
     return method_missing($str("puts"), $array(arg0));
  }
  default $O main($O arg0) {
     return method_missing($str("main"), $array(arg0));
  }
  default $O _plus($O arg0) {
     return method_missing($str("+"), $array(arg0));
  }
  
  @Override
  default $O $nomen$lang$Kernel$Int() {
    return ($O)new $nomen$lang$Kernel$Int();
  } 
  @Override
  default $O $Fib$Main() {
    return ($O)new $Fib$Main();
  } 
  
  default $O $Foo$MyFact() {
    return ($O)new $Foo$MyFact();
  } 
  @Override
  default $O $nomen$lang$Kernel$Nil() {
    return ($O)new $nomen$lang$Kernel$Nil();
  } 
  @Override
  default $O $nomen$lang$Kernel$Array() {
    return ($O)new $nomen$lang$Kernel$Array();
  } 
  
  default $O $Foo$Fact() {
    return ($O)new $Foo$Fact();
  } 
  @Override
  default $O $nomen$lang$Kernel$Block() {
    return ($O)new $nomen$lang$Kernel$Block();
  } 
  @Override
  default $O $Bar$A() {
    return ($O)new $Bar$A();
  } 
  
  default $O $Foo$Main() {
    return ($O)new $Foo$Main();
  } 
  @Override
  default $O $nomen$lang$Kernel$Bool() {
    return ($O)new $nomen$lang$Kernel$Bool();
  } 
  @Override
  default $O $Fib$XX() {
    return ($O)new $Fib$XX();
  } 
  @Override
  default $O $Fib$Bla() {
    return ($O)new $Fib$Bla();
  } 
  @Override
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
  @Override
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
  @Override
  default $O $Fib$Int() {
    return ($O)new $Fib$Int();
  } 
  

  interface $Self extends Foo<$Self> { }

  
  class $nomen$lang$Kernel$Int extends nomen.lang.Kernel.Int<$Self> implements $Self { } 
  
  class $Fib$Main extends Fib.Main<$Self> implements $Self { } 
  
  class $Foo$MyFact extends Foo.MyFact<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Nil extends nomen.lang.Kernel.Nil<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Array extends nomen.lang.Kernel.Array<$Self> implements $Self { } 
  
  class $Foo$Fact extends Foo.Fact<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Block extends nomen.lang.Kernel.Block<$Self> implements $Self { } 
  
  class $Bar$A extends Bar.A<$Self> implements $Self { } 
  
  class $Foo$Main extends Foo.Main<$Self> implements $Self { } 
  
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
  

  
  class Fact<$O extends Foo<$O>> extends nomen.lang.Kernel.Obj<$O> implements Foo<$O> {
    
  
    public Fact() { 
      super(); 
      
    }
    
  }
  
  class MyFact<$O extends Foo<$O>> extends Fib.Fact<$O> implements Foo<$O> {
    
  
    public MyFact() { 
      super(); 
      
    }
    
  }
  
  class Main<$O extends Foo<$O>> extends nomen.lang.Kernel.Obj<$O> implements Foo<$O> {
    
  
    public Main() { 
      super(); 
      
    }
    @Override
  public $O main($O args) {
    $O $ret = $nil();
    $O f = $ret = $new($Foo$MyFact(), $obj1045 -> { $obj1045.initialize(); return $obj1045; });
    $O i = $ret = $int(0);
    $O argsa = $ret = $int(3);
    $ret = (($O)Main.this).main(args);
    $O someClosure = $ret = $block(new nomen.lang.Kernel.Block<$O>() {
      @Override
      public $O call($O x) {
        $O $ret = $nil();
        $O x = $ret = $int(3);
        $ret = $new($Foo$Main(), $obj1045 -> { $obj1045.initialize(); return $obj1045; });
        return $ret;
      }
    });
    while ($truth((i)._leq($int(100)))) {
      $O x = $ret = $int(0);
      $O i = $ret = $int(3);
      $ret = (($O)Main.this).puts((f).fact(i));
      $ret = i = (i)._plus((($int(1))._star(x))._star(x));
    }
    $ret = $new($Fib$Bla(), $obj1045 -> { $obj1045.initialize(); return $obj1045; });
    $ret = $new($nomen$lang$Kernel$Int(), $obj1045 -> { $obj1045.initialize(); return $obj1045; });
    $ret = (($O)Main.this).puts((x)._plus(i));
    $ret = $new($Bar$A(), $obj1045 -> { $obj1045.initialize(); return $obj1045; });
    $O p = $ret = $new($Fib$Person(), $obj490 -> { $obj490.initialize($str("Tijs"), $int(34), $int(1), $int(2)); return $obj490; });
    $ret = (($O)Main.this).puts(p);
    return $ret;
  }
    
  }
  
  
  
  
  
  static void main(String[] args) {
    Main<$Self> main = new Main<$Self>();
    main.main(main.$args(args));
  }
  
}