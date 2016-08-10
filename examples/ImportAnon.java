 
@SuppressWarnings({"unchecked"})
public interface ImportAnon<$O extends ImportAnon<$O>> 
   extends Anon<$O>, nomen.lang.Kernel<$O> {
  
  default $O main() {
     return method_missing($str("main"), $array());
  }
  
  
  abstract class Main<$O extends ImportAnon<$O>> extends nomen.lang.Kernel.Obj<$O> implements ImportAnon<$O> {
    
  
    public Main() { 
      super(); 
      
    }
    @Override
  public $O main() {
    $O $ret = $nil();
    
    return $ret;
  }
    
  }
  
  
  
  
  
    
  $O $ImportAnon$Main();
    
  
}