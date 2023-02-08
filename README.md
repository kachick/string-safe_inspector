# string-safe_inspector

- _**This project now exists for very personal use**_.
- _**All versions have been removed from https://rubygems.org to free up valuable namespace for other developers**_.

![Build Status](https://github.com/kachick/string-safe_inspector/actions/workflows/test_behaviors.yml/badge.svg?branch=main)

Get `#inspect` without `exception` and `nil` possibilities

## Usage

Require Ruby 3.1 or later

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
