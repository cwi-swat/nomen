package diamond; 
@SuppressWarnings({"unchecked"})
public interface Top<$O extends Top<$O>> 
   extends diamond.B<$O>, diamond.A<$O>, nomen.lang.Kernel<$O> {
  
  default $O main($O arg0) {
     return method_missing($str("main"), $array(arg0));
  }
  default $O initialize() {
     return method_missing($str("initialize"), $array());
  }
  
  
  abstract class Main<$O extends diamond.Top<$O>> extends nomen.lang.Kernel.Obj<$O> implements diamond.Top<$O> {
    
  
    public Main() { 
      super(); 
      
    }
    @Override
  public $O main($O args) {
    $O $ret = $nil();
    $ret = $new($diamond$A$InA(), $obj1045 -> { $obj1045.initialize(); return $obj1045; });
    $ret = $new($diamond$B$InB(), $obj1045 -> { $obj1045.initialize(); return $obj1045; });
    return $ret;
  }
    
  }
  
  
  
  
  
    interface $Self extends Top<$Self> { }
    
    
    default $O $diamond$Top$Main() {
      return ($O)new $diamond$Top$Main();
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
    
    @Override
    default $O $nomen$lang$Kernel$Block() {
      return ($O)new $nomen$lang$Kernel$Block();
    }
    
    @Override
    default $O $nomen$lang$Kernel$Str() {
      return ($O)new $nomen$lang$Kernel$Str();
    }
    
    @Override
    default $O $diamond$Bot$Foo() {
      return ($O)new $diamond$Bot$Foo();
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
    default $O $nomen$lang$Kernel$Bool() {
      return ($O)new $nomen$lang$Kernel$Bool();
    }
    
    @Override
    default $O $diamond$A$InA() {
      return ($O)new $diamond$A$InA();
    }
    
    @Override
    default $O $diamond$B$InB() {
      return ($O)new $diamond$B$InB();
    }
     
    
    class $diamond$Top$Main extends diamond.Top.Main<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Int extends nomen.lang.Kernel.Int<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Obj extends nomen.lang.Kernel.Obj<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Nil extends nomen.lang.Kernel.Nil<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Array extends nomen.lang.Kernel.Array<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Block extends nomen.lang.Kernel.Block<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Str extends nomen.lang.Kernel.Str<$Self> implements $Self { } 
    
    class $diamond$Bot$Foo extends diamond.Bot.Foo<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Iter extends nomen.lang.Kernel.Iter<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Nihil extends nomen.lang.Kernel.Nihil<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Bool extends nomen.lang.Kernel.Bool<$Self> implements $Self { } 
    
    class $diamond$A$InA extends diamond.A.InA<$Self> implements $Self { } 
    
    class $diamond$B$InB extends diamond.B.InB<$Self> implements $Self { } 
    
    static void main(String[] args) {
      Main<$Self> main = new Main<$Self>() {};
      main.main(main.$args(args));
    }
  
}