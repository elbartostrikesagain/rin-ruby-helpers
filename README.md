# RinRubyHelpers
[![Build Status](https://travis-ci.org/elbartostrikesagain/rin-ruby-helpers.svg?branch=master)](https://travis-ci.org/elbartostrikesagain/rin-ruby-helpers)

This gem adds additional methods to the Rinruby gem which is used to connect to R. Currently, the only helpers are for single variable and multi variable regression on arrays of numbers, as well as an arrays of objects. Look at the /specs for documentation.

Word of caution: RinRuby is not the fastest way to use R with ruby(infact it is the slowest), and large regressions are probably fairly slow. I recommend doing large regressions in a background worker.

## Installation

Add this line to your application's Gemfile:

    gem 'rin_ruby_helpers', git: 'git://github.com/elbartostrikesagain/rin-ruby-helpers.git'

And then execute:

    $ bundle install

## Dependencies
R

## Usage

I highly recommend viewing the specs for usage but here is some documentation:


Install and require RinRuby then include the helpers module on the RinRuby class like so:

```
Class RinRuby
  include RinRubyHelpers
end
```

then you can use the additional helper methods:

#### predict from arrays:
```
rinruby = RinRuby.new

training_data = [[1,2,3,4], [2,4,6,8]]
predict_data = [5]
rinruby.regression_prediction(training_data: training_data, predict_data: predict) #=> 10
rinruby.quit
```

#### predict from objects:
```
#given an example class that has methods air_flow, water_temp and acid_concentration which are features (independent variables)
#predict on stack_loss (dependent variable)

class StackLoss
  attr_accessor :air_flow, :water_temp, :acid_concentration, :stack_loss
end

stack_losses = [...] #array of StackLoss objects
predict_data = [72, 20, 85] #predict given [air_flow, water_temp, acid_concentration]
stack_loss_features =
predict_method = :stack_loss

rinruby.regression_prediction(training_data: stack_losses,
                              predict_data: predict,
                              features: [:air_flow, :water_temp, :acid_concentration],
                              predict_method: :stack_loss)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
