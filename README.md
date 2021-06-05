# string-safe_inspector

![Build Status](https://github.com/kachick/string-safe_inspector/actions/workflows/test_behaviors.yml/badge.svg?branch=main)
[![Gem Version](https://badge.fury.io/rb/string-safe_inspector.png)](http://badge.fury.io/rb/string-safe_inspector)

Get `#inspect` without `exception` and `nil` possibilities

## Usage

Require Ruby 2.6 or later

Add below code into your Gemfile

```ruby
gem 'string-safe_inspector', '>= 0.0.1', '< 0.1.0'
```

### Overview

```ruby
require 'string/safe_inspector'

does_not_have_inspect = BasicObject.new; nil

begin
  p does_not_have_inspect
rescue => err
  p err
end
#=> #<NoMethodError: undefined method `inspect' for #<BasicObject:0x00007fd1500fa680>>

String::SafeInspector.inspect_for(does_not_have_inspect)
#=>  "#<BasicObject:0x00007fd1500fa680>"
```

## Links

* [Repository](https://github.com/kachick/string-safe_inspector)
* [API documents](https://kachick.github.io/string-safe_inspector/)
