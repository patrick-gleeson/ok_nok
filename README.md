# ok_nok
A utility for adding a variant of functional-style Either return values to Ruby code.

##Rationale
Functional programming includes the concept of the Either, a return value that has a Left or a Right. Traditionally a populated Left value represents failure, and can contain information about the failure and a populated Right represents success.
That's nicely generic, but it's also hard to read and unintuitive unless you're used to the syntax.

It's very common in MVC apps in particular to want to return either a successful result or nothing - e.g. when retrieving a Model object by ID from a database. 
The Option type, which returns either a Some instance or a None object, is designed to handle this, but it lacks the any way of indicating what went wrong in a None situation.

So what we're looking for is a neat way of either returning a value if an operation completed successfully, or returning an error explanation if it didn't. And we want it to be impossible to mistake the error explanation for a valid returned result.

Either classes are too generic, as are Scala-style tuples. Option classes are too limited. Raising Exceptions is a bit heavy-handed. Presenting, then, ok_nok.

##Usage
An ok_nok function always returns an instance of OkNok, whose status is set to either `ok` or `nok` (not ok). `ok` and `nok` methods monkey-patched into the Object class make this easy, e.g.:

    def multiple_foos(multiplier)
      if (inted = Integer(multiplier) rescue false)
        ok("foo" * inted)
      else
        nok("'#{multiplier}' can't be converted to an Integer so can't be used to multiply foo")
      end
    end
    
At the most basic level you can then query the OkNok object about its status, like so:

    result = multiple_foos(gets)
    if result.ok?
      puts result.value
    else
      puts "Uh-Oh! #{result.value}"
    end
    
But OkNoks also enable other, slightly more powerful control flow structures, e.g.:

    result = multiple_foos(gets).or_if_nok do |nok|
      # The code here only gets executed if multiple_foos is not ok
    end
     
    # result will be nil if multiple_foos is not_ok
    
Also you can do:

    multiple_foos(gets).ok {|ok| 
      #This block gets called if multiple_foos is ok 
    }.nok {|nok| 
      #This block gets called if multiple_foos is not ok
    }
    

##Licence
Licensed under the MIT licence.

