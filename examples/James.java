 
@SuppressWarnings({"unchecked"})
public interface James<$O extends James<$O>> 
   extends nomen.lang.Kernel<$O> {
  
  default $O _plus($O arg0) {
     return method_missing($str("+"), $array(arg0));
  }
  default $O _leq($O arg0) {
     return method_missing($str("<="), $array(arg0));
  }
  default $O puts($O arg0) {
     return method_missing($str("puts"), $array(arg0));
  }
  default $O main($O arg0) {
     return method_missing($str("main"), $array(arg0));
  }
  
  
  abstract class Main<$O extends James<$O>> extends nomen.lang.Kernel.Obj<$O> implements James<$O> {
    
    
  
    public Main() { 
      super(); 
      
    }
    @Override
  public $O main($O args) {
    	long total = 0;
    	$O $ret = $nil();
  		
    	for (int j = 0; j < 1000; j++) {
    		long n = System.currentTimeMillis();
    		$O i = $ret = $int(1);
    		$O sum = $ret = $int(0);
    		while ($truth((i)._leq($int(1000000)))) {
    			$ret = sum = (sum)._plus(i);
    			$ret = i = (i)._plus($int(1));
    		}
    		long n2 = System.currentTimeMillis();
    		total += n2 - n;
    		$ret = (($O)Main.this).puts(sum);
    	}
    	
    	System.out.println((total * 1.0) / 1000.0);
    	return $ret;
  }
    
  }
  
  
  
  
  
    interface $Self extends James<$Self> { }
    
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
    default $O $nomen$lang$Kernel$Bool() {
      return ($O)new $nomen$lang$Kernel$Bool();
    }
    
    
    default $O $James$Main() {
      return ($O)new $James$Main();
    }
    
    @Override
    default $O $nomen$lang$Kernel$Iter() {
      return ($O)new $nomen$lang$Kernel$Iter();
    }
    
    @Override
    default $O $nomen$lang$Kernel$Nihil() {
      return ($O)new $nomen$lang$Kernel$Nihil();
    }
     
    
    class $nomen$lang$Kernel$Int extends nomen.lang.Kernel.Int<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Obj extends nomen.lang.Kernel.Obj<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Nil extends nomen.lang.Kernel.Nil<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Array extends nomen.lang.Kernel.Array<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Block extends nomen.lang.Kernel.Block<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Str extends nomen.lang.Kernel.Str<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Bool extends nomen.lang.Kernel.Bool<$Self> implements $Self { } 
    
    class $James$Main extends James.Main<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Iter extends nomen.lang.Kernel.Iter<$Self> implements $Self { } 
    
    class $nomen$lang$Kernel$Nihil extends nomen.lang.Kernel.Nihil<$Self> implements $Self { } 
    
    static void main(String[] args) {
      Main<$Self> main = new Main<$Self>() {};
      main.main(main.$args(args));
    }
  
}