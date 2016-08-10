package diamond; 
@SuppressWarnings({"unchecked"})
public interface Bot<$O extends Bot<$O>> 
   extends nomen.lang.Kernel<$O> {
  
  
  
  abstract class Foo<$O extends diamond.Bot<$O>> extends nomen.lang.Kernel.Obj<$O> implements diamond.Bot<$O> {
    
  
    public Foo() { 
      super(); 
      
    }
    
  }
  
  
  
  
  
    
  $O $diamond$Bot$Foo();
    
  
}