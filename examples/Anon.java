 
@SuppressWarnings({"unchecked"})
public interface Anon<$O extends Anon<$O>> 
   extends nomen.lang.Kernel<$O> {
  
  default $O g() {
     return method_missing($str("g"), $array());
  }
  default $O _plus($O arg0) {
     return method_missing($str("+"), $array(arg0));
  }
  default $O initialize() {
     return method_missing($str("initialize"), $array());
  }
  default $O puts($O arg0) {
     return method_missing($str("puts"), $array(arg0));
  }
  default $O f() {
     return method_missing($str("f"), $array());
  }
  default $O main($O arg0) {
     return method_missing($str("main"), $array(arg0));
  }
  
  
  abstract class Bla<$O extends Anon<$O>> extends nomen.lang.Kernel.Obj<$O> implements Anon<$O> {
    
  
    public Bla() { 
      super(); 
      
    }
    @Override
  public $O f() {
    $O $ret = $nil();
    $O y = $ret = $new($Anon$Anon_examples_Anon_nomen_44(), $obj44 -> { $obj44.initialize(); return $obj44; });
    $O x = $ret = $new($Anon$Anon_examples_Anon_nomen_78(), $obj78 -> { $obj78.initialize(); return $obj78; });
    $ret = (($O)Bla.this).puts(($str("y.g = "))._plus((y).g()));
    $ret = (($O)Bla.this).puts(($str("x.g = "))._plus((x).g()));
    return $ret;
  }
    @Override
  public $O g() {
    $O $ret = $nil();
    $ret = $str("bla");
    return $ret;
  }
    
  }
  
  abstract class Main<$O extends Anon<$O>> extends nomen.lang.Kernel.Obj<$O> implements Anon<$O> {
    
  
    public Main() { 
      super(); 
      
    }
    @Override
  public $O main($O args) {
    $O $ret = $nil();
    $O b = $ret = $new($Anon$Bla(), $obj1045 -> { $obj1045.initialize(); return $obj1045; });
    $ret = (b).f();
    return $ret;
  }
    
  }
  
  
  
  abstract class Anon_examples_Anon_nomen_44<$O extends Anon<$O>> extends nomen.lang.Kernel.Obj<$O> implements Anon<$O> {
    
  
    public Anon_examples_Anon_nomen_44() { 
      super(); 
      
    }
    @Override
  public $O g() {
    $O $ret = $nil();
    $ret = ($int(1))._plus($int(2));
    return $ret;
  }
    
  }
  
  abstract class Anon_examples_Anon_nomen_78<$O extends Anon<$O>> extends Anon.Bla<$O> implements Anon<$O> {
    
  
    public Anon_examples_Anon_nomen_78() { 
      super(); 
      
    }
    @Override
  public $O g() {
    $O $ret = $nil();
    $ret = ($str("overridden "))._plus(super.g());
    return $ret;
  }
    
  }
  
  
  
    interface $Self extends Anon<$Self> { }
    
    
    default $O $Anon$Anon_examples_Anon_nomen_44() {
      return ($O)new $Anon$Anon_examples_Anon_nomen_44();
    }
    
    @Override
    default $O $nomen$lang$Kernel$Int() {
      return ($O)new $nomen$lang$Kernel$Int();
    }
    
    @Override
    default $O $nomen$lang$Kernel$Obj() {
      return ($O)new $nomen$lang$Kernel$Obj();
    }
    
    @Override
    default $O $nomen$lang$Kernel$Nil() {
      return ($O)new $nomen$lang$Kernel$Nil();
    }
    
    @Override
    default $O $nomen$lang$Kernel$Array() {
      return ($O)new $nomen$lang$Kernel$Array();
    }
    
    
    default $O $Anon$Bla() {
      return ($O)new $Anon$Bla();
    }
    
    @Override
    default $O $nomen$lang$Kernel$Block() {
      return ($O)new $nomen$lang$Kernel$Block();
    }
    
    
    default $O $Anon$Main() {
      return ($O)new $Anon$Main();
    }
    
    @Override
    default $O $nomen$lang$Kernel$Bool() {
      return ($O)new $nomen$lang$Kernel$Bool();
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
    default $O $nomen$lang$Kernel$Str() {
      return ($O)new $nomen$lang$Kernel$Str();
    }
    
    
    default $O $Anon$Anon_examples_Anon_nomen_78() {
      return ($O)new $Anon$Anon_examples_Anon_nomen_78();
    }
     
    
    class $Anon$Anon_examples_Anon_nomen_44 extends Anon.Anon_examples_Anon_nomen_44<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Int extends nomen.lang.Kernel.Int<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Obj extends nomen.lang.Kernel.Obj<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Nil extends nomen.lang.Kernel.Nil<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Array extends nomen.lang.Kernel.Array<$Self> implements $Self { } 
    
    class $Anon$Bla extends Anon.Bla<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Block extends nomen.lang.Kernel.Block<$Self> implements $Self { } 
    
    class $Anon$Main extends Anon.Main<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Bool extends nomen.lang.Kernel.Bool<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Iter extends nomen.lang.Kernel.Iter<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Nihil extends nomen.lang.Kernel.Nihil<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Str extends nomen.lang.Kernel.Str<$Self> implements $Self { } 
    
    class $Anon$Anon_examples_Anon_nomen_78 extends Anon.Anon_examples_Anon_nomen_78<$Self> implements $Self { } 
    
    static void main(String[] args) {
      Main<$Self> main = new Main<$Self>() {};
      main.main(main.$args(args));
    }
  
}