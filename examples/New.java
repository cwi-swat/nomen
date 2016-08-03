 
@SuppressWarnings({"unchecked"})
public interface New<$O extends New<$O>> 
   extends nomen.lang.Kernel<$O> {
  
  default $O f() {
     return method_missing($str("f"), $array());
  }
  default $O initialize($O arg0, $O arg1, $O arg2, $O arg3) {
     return method_missing($str("initialize"), $array(arg0, arg1, arg2, arg3));
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
  
  default $O $New$Foo() {
    return ($O)new $New$Foo();
  } 
  @Override
  default $O $nomen$lang$Kernel$Str() {
    return ($O)new $nomen$lang$Kernel$Str();
  } 
  @Override
  default $O $nomen$lang$Kernel$Bool() {
    return ($O)new $nomen$lang$Kernel$Bool();
  } 
  

  interface $Self extends New<$Self> { }

  
  class $nomen$lang$Kernel$Int extends nomen.lang.Kernel.Int<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Iter extends nomen.lang.Kernel.Iter<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Obj extends nomen.lang.Kernel.Obj<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Nil extends nomen.lang.Kernel.Nil<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Array extends nomen.lang.Kernel.Array<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Block extends nomen.lang.Kernel.Block<$Self> implements $Self { } 
  
  class $New$Foo extends New.Foo<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Str extends nomen.lang.Kernel.Str<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Bool extends nomen.lang.Kernel.Bool<$Self> implements $Self { } 
  

  
  class Foo<$O extends New<$O>> extends nomen.lang.Kernel.Obj<$O> implements New<$O> {
    
  
    public Foo() { 
      super(); 
      
    }
    @Override
  public $O f() {
    $O $ret = $nil();
    $ret = $new($New$Foo(), $obj35 -> { $obj35.initialize($int(1), $int(2), $int(3), $int(4)); return $obj35; });
    return $ret;
  }
    
  }
  
  
  
}