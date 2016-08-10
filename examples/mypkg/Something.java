package mypkg; 
@SuppressWarnings({"unchecked"})
public interface Something<$O extends Something<$O>> 
   extends nomen.lang.Kernel<$O> {
  
  
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
  
  default $O $mypkg$Something$Bla() {
    return ($O)new $mypkg$Something$Bla();
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
  @Override
  default $O $nomen$lang$Kernel$Iter() {
    return ($O)new $nomen$lang$Kernel$Iter();
  } 
  @Override
  default $O $nomen$lang$Kernel$Nihil() {
    return ($O)new $nomen$lang$Kernel$Nihil();
  } 
  

  interface $Self extends Something<$Self> { }

  
  class $nomen$lang$Kernel$Int extends nomen.lang.Kernel.Int<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Obj extends nomen.lang.Kernel.Obj<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Nil extends nomen.lang.Kernel.Nil<$Self> implements $Self { } 
  
  class $mypkg$Something$Bla extends mypkg.Something.Bla<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Array extends nomen.lang.Kernel.Array<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Block extends nomen.lang.Kernel.Block<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Str extends nomen.lang.Kernel.Str<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Bool extends nomen.lang.Kernel.Bool<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Iter extends nomen.lang.Kernel.Iter<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Nihil extends nomen.lang.Kernel.Nihil<$Self> implements $Self { } 
  

  
  class Bla<$O extends mypkg.Something<$O>> extends nomen.lang.Kernel.Obj<$O> implements mypkg.Something<$O> {
    
  
    public Bla() { 
      super(); 
      
    }
    
  }
  
  
  
}