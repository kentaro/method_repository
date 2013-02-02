# MethodRepository  [![BuildStatus](https://secure.travis-ci.org/kentaro/method_repository.png)](http://travis-ci.org/kentaro/method_repository)

Extracting redundant code and commonalizing it in a different way.

## Problem

To extract redundant codes into a method to commonalize them is a usual strategy for OOP. It allows us to streamline our codes and modify at one stop even though the method is used at anywhere, anytimes.

I don't like when highly commonalized OOP structure disturbes me from quick tracing where such methods are defined. It's OOP's natural defect, I think. Once  classes/modules are defined, it's inevitable that the classes/modules are inherited/included at anywhere we don't know.

In that way, inheritance/inclusion-based OOP resembles `goto` programming; There's no clear reason why some classes/modules are inherited/included by another classes/modules. Even though there's some structural thought in your classes/modules design, such an excessively free inheritance/inclusion prevent us from grasping the whole code quickily.

## Solution

This library provides a "method repository" in which you can add your methods to commonalize redundant codes here and there in your whole codes, which is just same as usual module usage. However, the methods you define in the "repository" will never be included automatically into other classes/modules unless not permitted explicitely.

This is the point; There's no chance the methods in the "repository" appear at somewhere the "repository" don't know. To commonalize redundancy is our intension, but we don't want the methods to be used where we don't know. The way this library provides solves the problem.

## Usage

Imagine there's such a code below:

```ruby
module Repository
  include MethodRepository

  insert :method1, in: %w[Foo Bar] do; end
  insert :method2, in: %w[Baz]     do; end
end

class Foo; end
class Bar; end
class Baz; end
class Qux; end
```

  * `method1` is declared it can be inserted in `Foo` and `Bar`
  * `method2` is declared it can be inserted in only `Baz`
  * No method is declared it can be inserted in `Qux`

### Extending

When the classes/objects are extended by `Repository` module:

```ruby
Foo.extend(Repository)
Bar.extend(Repository)
Baz.extend(Repository)
Qux.extend(Repository)
```

or

```ruby
foo = Foo.new; foo.extend(Repository)
bar = Bar.new; bar.extend(Repository)
baz = Baz.new; bar.extend(Repository)
qux = Qux.new; qux.extend(Repository)
```

Only explicitely permitted methods are defined as singleton methods of each classes/objects. That results in:

```ruby
Foo.respond_to?(:method1) #=> true
Bar.respond_to?(:method1) #=> true
Baz.respond_to?(:method1) #=> false
Qux.respond_to?(:method1) #=> false

Foo.respond_to?(:method2) #=> false
Bar.respond_to?(:method2) #=> false
Baz.respond_to?(:method2) #=> true
Qux.respond_to?(:method2) #=> false
```

or

```ruby
foo.respond_to?(:method1) #=> true
bar.respond_to?(:method1) #=> true
baz.respond_to?(:method1) #=> false
qux.respond_to?(:method1) #=> false

foo.respond_to?(:method2) #=> false
bar.respond_to?(:method2) #=> false
baz.respond_to?(:method2) #=> true
qux.respond_to?(:method2) #=> false
```

### Including

The rule is also applicable to `include`:

```ruby
Foo.send(:include, Repository)
Bar.send(:include, Repository)
Baz.send(:include, Repository)
Qux.send(:include, Repository)
```

Results in:

```ruby
Foo.new.respond_to?(:method1) #=> true
Bar.new.respond_to?(:method1) #=> true
Baz.new.respond_to?(:method1) #=> false
Qux.new.respond_to?(:method1) #=> false

Foo.new.respond_to?(:method2) #=> false
Bar.new.respond_to?(:method2) #=> false
Baz.new.respond_to?(:method2) #=> true
Qux.new.respond_to?(:method2) #=> false
```

In this case, the methods in `Repository` are, of course, defined as instance methods of each classes, not singleton methods of each objects.

## Installation

Add this line to your application's Gemfile:

    gem 'method_repository'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install method_repository

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
