 
@SuppressWarnings({"unchecked", "unused"})
public interface Baz<$O extends Baz<$O>>
   
   extends Foo<$O>, nomen.lang.Kernel<$O>
   {
  
  
  @Override
  default $O $nomen$lang$Kernel$Int() {
    return ($O)new $nomen$lang$Kernel$Int();
  } 
  @Override
  default $O $Fib$Main() {
    return ($O)new $Fib$Main();
  } 
  @Override
  default $O $nomen$lang$Kernel$Iter() {
    return ($O)new $nomen$lang$Kernel$Iter();
  } 
  @Override
  default $O $Foo$MyFact() {
    return ($O)new $Foo$MyFact();
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
  default $O $Foo$Fact() {
    return ($O)new $Foo$Fact();
  } 
  @Override
  default $O $nomen$lang$Kernel$Block() {
    return ($O)new $nomen$lang$Kernel$Block();
  } 
  @Override
  default $O $Bar$A() {
    return ($O)new $Bar$A();
  } 
  @Override
  default $O $Foo$Main() {
    return ($O)new $Foo$Main();
  } 
  @Override
  default $O $nomen$lang$Kernel$Bool() {
    return ($O)new $nomen$lang$Kernel$Bool();
  } 
  @Override
  default $O $Fib$XX() {
    return ($O)new $Fib$XX();
  } 
  @Override
  default $O $Fib$Bla() {
    return ($O)new $Fib$Bla();
  } 
  @Override
  default $O $Fib$Person() {
    return ($O)new $Fib$Person();
  } 
  @Override
  default $O $Fib$Fact() {
    return ($O)new $Fib$Fact();
  } 
  @Override
  default $O $nomen$lang$Kernel$Obj() {
    return ($O)new $nomen$lang$Kernel$Obj();
  } 
  @Override
  default $O $nomen$lang$Kernel$Str() {
    return ($O)new $nomen$lang$Kernel$Str();
  } 
  @Override
  default $O $Fib$Int() {
    return ($O)new $Fib$Int();
  } 
  

  interface $Self extends Baz<$Self> { }

  
  class $nomen$lang$Kernel$Int extends nomen.lang.Kernel.Int<$Self> implements $Self { } 
  
  class $Fib$Main extends Fib.Main<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Iter extends nomen.lang.Kernel.Iter<$Self> implements $Self { } 
  
  class $Foo$MyFact extends Foo.MyFact<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Nil extends nomen.lang.Kernel.Nil<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Array extends nomen.lang.Kernel.Array<$Self> implements $Self { } 
  
  class $Foo$Fact extends Foo.Fact<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Block extends nomen.lang.Kernel.Block<$Self> implements $Self { } 
  
  class $Bar$A extends Bar.A<$Self> implements $Self { } 
  
  class $Foo$Main extends Foo.Main<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Bool extends nomen.lang.Kernel.Bool<$Self> implements $Self { } 
  
  class $Fib$XX extends Fib.XX<$Self> implements $Self { } 
  
  class $Fib$Bla extends Fib.Bla<$Self> implements $Self { } 
  
  class $Fib$Person extends Fib.Person<$Self> implements $Self { } 
  
  class $Fib$Fact extends Fib.Fact<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Obj extends nomen.lang.Kernel.Obj<$Self> implements $Self { } 
  
  class $nomen$lang$Kernel$Str extends nomen.lang.Kernel.Str<$Self> implements $Self { } 
  
  class $Fib$Int extends Fib.Int<$Self> implements $Self { } 
  

  
  
  
}