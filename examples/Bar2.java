 
@SuppressWarnings({"unchecked"})
public interface Bar2<$O extends Bar2<$O>> 
   extends Bar<$O>, nomen.lang.Kernel<$O> {
  
  
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
  
  default $O $Bar2$A() {
    return ($O)new $Bar2$A();
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
  default $O $Bar$A() {
    return ($O)new $Bar$A();
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
  

  interface $Self extends Bar2<$Self> { }

  
  class $nomen$lang$Kernel$Int extends nomen.lang.Kernel.Int<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Obj extends nomen.lang.Kernel.Obj<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Nil extends nomen.lang.Kernel.Nil<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Array extends nomen.lang.Kernel.Array<$Self> implements $Self { } 
  
  class $Bar2$A extends Bar2.A<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Block extends nomen.lang.Kernel.Block<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Str extends nomen.lang.Kernel.Str<$Self> implements $Self { } 
  
  class $Bar$A extends Bar.A<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Bool extends nomen.lang.Kernel.Bool<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Iter extends nomen.lang.Kernel.Iter<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Nihil extends nomen.lang.Kernel.Nihil<$Self> implements $Self { } 
  

  
  class A<$O extends Bar2<$O>> extends nomen.lang.Kernel.Obj<$O> implements Bar2<$O> {
    
  
    public A() { 
      super(); 
      
    }
    
  }
  
  
  
  
  
}