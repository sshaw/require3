# require3

`Kernel#require` something and make its contents accessible via a different namespace.

[![Build Status](https://travis-ci.org/sshaw/require3.svg?branch=master)](https://travis-ci.org/sshaw/require3)

## Usage

```rb
require "require3"  # Oh the irony
```

Now load the desired files and specify some rules:
```rb
require3 "some/very/long/name/here" => "*"
```

This will make everything accessible via the top-level namespace. It's the same as:
```rb
require "some/very/long/name/here"
include Some::Very::Long::Name::Here
```

Or access it as `Foo`:
```rb
require3 "some/very/long/name/here" => "foo"
```

Same as:
```rb
require "some/very/long/name/here"
Foo = Some::Very::Long::Name::Here
```

If you only want to access `Foo` and `Bar`:
```rb
require3 "some/very/long/name/here" => %w[foo bar]
```

Same as:
```rb
require "some/very/long/name/here"
Foo = Some::Very::Long::Name::Here::Foo
Bar = Some::Very::Long::Name::Here::Bar
```

You can also provide the names as `Symbol`s and/or using their proper case:
```rb
require3 "some/very/long/name/here" => [:Foo, "Bar"]
```

Use a `Hash` to specify alternate names:
```rb
require3 "some/very/long/name/here" => { :foo => "foo_hoo", :bar => "BarHar" }
```


Same as:
```rb
require "some/very/long/name/here"
FooHoo = Some::Very::Long::Name::Here::Foo
BarHar = Some::Very::Long::Name::Here::Bar
```

Or:
```
require3 "some/very/long/name/here" => { "Some::Very::Foo" => "foo", :bar => "BarHar" }
```

Same as:
```rb
require "some/very/long/name/here"
Foo = Some::Very::Foo
BarHar = Some::Very::Long::Name::Here::Bar
```

`require3` mostly behaves like `Kernerl#require` but, if what you want to alias does not exist, a `NameError` will be raised.

Path names are converted to class names using the same rules as [Rails' `String#camelize`](https://api.rubyonrails.org/v4.2.6/classes/ActiveSupport/Inflector.html#method-i-camelize) (though this library _is not_ a dependency). If this conversion fails you must explicitly provide the name. A convoluted example:

```rb
# This fails as we try to alias Net::Http
require3 "net/http" => "n"

# Do this instead
require3 "net/http" => { "Net::HTTP" => "n" }
```

## See Also

* [aliased](https://metacpan.org/pod/aliased) - The Perl module that served as inspiration
* [Modulation](https://github.com/digital-fabric/modulation) - Add explicit import and export declarations to your code
* [class2](https://github.com/sshaw/class2) - Easily create hierarchies that support nested attributes, type conversion, serialization and more
* [alias2](https://github.com/sshaw/alias2) - Make classes, modules, and constants accessible via a different namespace.

## Author

Skye Shaw [skye.shaw AT gmail]

## License

Released under the MIT License: http://www.opensource.org/licenses/MIT
