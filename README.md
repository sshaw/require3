# require2

`Kernel#require` something and make it accessible via a different namespace.

[![Build Status](https://travis-ci.org/sshaw/require2.svg?branch=master)](https://travis-ci.org/sshaw/require2)

## Usage

```rb
require "require2"  # Oh the irony
```

Then:

```rb
require2 "some/very/long/name/here" => "*"

# Same as:
require "some/very/long/name/here"
Foo = Some::Very::Long::Name::Here::Foo
Bar = Some::Very::Long::Name::Here::Bar
CONSTANT = Some::Very::Long::Name::Here::CONSTANT
# ...
# For all constants in Some::Very::Long::Name::Here

require2 "some/very/long/name/here" => "foo"

# Same as:
require "some/very/long/name/here"
Foo = Some::Very::Long::Name::Here

require2 "some/very/long/name/here" => %w[foo bar]

# Same as:
require "some/very/long/name/here"
Foo = Some::Very::Long::Name::Here::Foo
Bar = Some::Very::Long::Name::Here::Bar

require2 "some/very/long/name/here" => { :foo => "foo_hoo", :bar => "BarHar" }

# Same as:
require "some/very/long/name/here"
FooHoo = Some::Very::Long::Name::Here::Foo
BarHar = Some::Very::Long::Name::Here::Bar

require2 "some/very/long/name/here" => { "Some::Very::Foo" => "foo", :bar => "BarHar" }

# Same as:
require "some/very/long/name/here"
Foo = Some::Very::Foo
BarHar = Some::Very::Long::Name::Here::Bar
```

`require2` mostly behaves like `Kernerl#require` but, if what you want to alias does not exist, a `NameError` will be raised.

Path names are converted to class names using the same rules as [Rails' `String#camelize`](https://api.rubyonrails.org/v4.2.6/classes/ActiveSupport/Inflector.html#method-i-camelize) (though this library _is not_ a dependency). If this conversion fails you must explicitly provide the name. A convoluted example:

```rb
# This fails as we try to alias Net::Http
require2 "net/http" => "n"

# Do this instead
require2 "net/http" => { "Net::HTTP" => "n" }
```

## See Also

* [aliased](https://metacpan.org/pod/aliased) - The Perl module that served as inspiration
* [Modulation](https://github.com/digital-fabric/modulation) - Add explicit import and export declarations to your code
* [class2](https://github.com/sshaw/class2) - Easily create hierarchies that support nested attributes, type conversion, serialization and more

## Author

Skye Shaw [skye.shaw AT gmail]

## License

Released under the MIT License: http://www.opensource.org/licenses/MIT
