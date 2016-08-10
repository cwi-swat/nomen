package diamond; 
@SuppressWarnings({"unchecked"})
public interface A<$O extends A<$O>> 
   extends diamond.Bot<$O>, nomen.lang.Kernel<$O> {
  
  
  
  abstract class InA<$O extends diamond.A<$O>> extends diamond.Bot.Foo<$O> implements diamond.A<$O> {
    
  
    public InA() { 
      super(); 
      
    }
    
  }
  
  
  
  
  
    
  $O $diamond$A$InA();
    
  
}