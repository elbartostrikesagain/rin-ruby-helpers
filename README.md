# RinRubyHelpers
[![Build Status](https://travis-ci.org/elbartostrikesagain/rin-ruby-helpers.svg?branch=master)](https://travis-ci.org/elbartostrikesagain/rin-ruby-helpers)

This gem adds additional methods to the Rinruby gem which is used to connect to R. Currently, it only has the ability to run single variable and multi variable regression on arrays of numbers, as well as an arrays of objects. Look at the /specs for documentation.

## Installation

Add this line to your application's Gemfile:

    gem 'rin_ruby_helpers', git: 'git://github.com/elbartostrikesagain/rin-ruby-helpers.git'

And then execute:

    $ bundle install

## Usage

```
Class RinRuby
  include RinRubyHelpers
end
```

(then see specs for usage on added methods)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
