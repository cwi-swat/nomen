package mypkg; 
@SuppressWarnings({"unchecked"})
public interface Something<$O extends Something<$O>> 
   extends nomen.lang.Kernel<$O> {
  
  
  
  abstract class Bla<$O extends mypkg.Something<$O>> extends nomen.lang.Kernel.Obj<$O> implements mypkg.Something<$O> {
    
  
    public Bla() { 
      super(); 
      
    }
    
  }
  
  
  
  
  
    
  $O $mypkg$Something$Bla();
    
  
}