# ok_nok
A utility for adding a variant of functional-style Either return values to Ruby code.

[![Codeship Status for patrick-gleeson/ok_nok](https://www.codeship.io/projects/e971b5a0-e9b3-0132-e2ca-4602e60b2e9f/status?branch=master)](https://www.codeship.io/projects/82985)

##Rationale
Functional programming includes the concept of the Either, a return value that has a Left or a Right. Traditionally a populated Left value represents failure, and can contain information about the failure and a populated Right represents success.
That's nicely generic, but it's also hard to read and unintuitive unless you're used to the syntax.

It's very common in MVC apps in particular to want to return either a successful result or nothing - e.g. when retrieving a Model object by ID from a database. 
The Option type, which returns either a Some instance or a None object, is designed to handle this, but it lacks the any way of indicating what went wrong in a None situation.

So what we're looking for is a neat way of either returning a value if an operation completed successfully, or returning an error explanation if it didn't. And we want it to be impossible to mistake the error explanation for a valid returned result.

Either classes are too generic, as are Scala-style tuples. Option classes are too limited. Raising Exceptions is a bit heavy-handed. Presenting, then, ok_nok.

##Installation
As per any gem published on RubyGems, add `gem 'ok_nok'` to your gemfile and do a command line `bundle`, or just run `gem install ok_nok`.

##Usage
An ok_nok function always returns an instance of OkNok, whose status is set to either `ok` or `nok` (not ok). `ok` and `nok` methods monkey-patched into the Object class make this easy, e.g.:

    def multiple_foos(multiplier)
      if (intified = Integer(multiplier) rescue false)
        ok("foo" * intified)
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
    
But OkNoks also enable other, slightly more convenient control structures, e.g.:

    result = multiple_foos(gets).value_or_if_nok do |nok_value|
      # The code here only gets executed if multiple_foos is not ok
    end
    
    # result will be either the ok value, or the return value of the block
    
Also you can do:

    multiple_foos(gets).ok {|ok_value| 
      #This block gets called if multiple_foos is ok 
    }.nok {|nok_value| 
      #This block gets called if multiple_foos is not ok
    }
    
You can wrap a block in an OkNok, if you specify what a nok result looks like:

    result = OkNok.nok_if(nil, "No 'e' was found") do
      gets.index("e")
    end
    
Finally, you can wrap a block in an OkNok and have it return a nok only if an exception is raised

    result = OkNok.nok_if_exception("Uh-oh, my block raised an exception") do
      Integer(gets)
    end

Note that in the above examples the nok value has been a user-friendly error message string. Of course, this could be a L10n key, a symbol, a Proc, or any sort of object that helps you deal with not-ok scenarios.


##Licence
Licensed under the MIT licence.
