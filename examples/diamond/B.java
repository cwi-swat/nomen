package diamond; 
@SuppressWarnings({"unchecked"})
public interface B<$O extends B<$O>> 
   extends nomen.lang.Kernel<$O>, diamond.Bot<$O> {
  
  
  
  abstract class InB<$O extends diamond.B<$O>> extends diamond.Bot.Foo<$O> implements diamond.B<$O> {
    
  
    public InB() { 
      super(); 
      
    }
    
  }
  
  
  
  
  
    
  $O $diamond$B$InB();
    
  
}