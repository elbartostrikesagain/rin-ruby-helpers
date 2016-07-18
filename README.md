# RinRubyHelpers
[![Build Status](https://travis-ci.org/elbartostrikesagain/rin-ruby-helpers.svg?branch=master)](https://travis-ci.org/elbartostrikesagain/rin-ruby-helpers)

## What does this do?

This gem adds additional methods to the Rinruby gem which is used to connect to R. Currently, the only helpers are for linear regression on arrays of numbers, as well as an arrays of objects. The goal of this gem is to make implementing statistical methods(and types of machine learning that use these methods) easy to rubists to use, with minimal dependencies. Other gems that currently do this are the simplestats gem but it has many more dependencies which are very out of date.

#### About Linear regressions

Linear regression is a type of supervised learning that models the relationship between scalar dependent and explanatory values. This allows you to infer a function from training data.
For example, you could predict the price of a house given the number of square feet of a house. You would take an array of house objects, where a house object has a price, number of square feet, create a linear regression, evaluate if there is a correlation between these variables, and then predict house prices on other house objects of unknown prices(first example in usage below). (Note this is a simple example - there are many other things that should be factored in when estimating the price of a house.)


![sample house price image](https://cloud.githubusercontent.com/assets/398104/16933447/b166fda0-4d0a-11e6-9afb-d0c6ed538f8c.png "house price sample image")

#### Other notes

Currently, the only supported helper methods are for the R `lm` method (linear model). There are other types of regressions that might suite your needs better. If they are available in R, please contribute.

Word of caution: RinRuby is not the fastest way to use R with ruby(infact it is the slowest of the popular gems to interface with R), and large regressions are probably fairly slow. Slow tasks are great canidates for background workers when possible. Additionally, you can also store the equation via the estimates variables for fast predictions(only retraining is slow then).

This Gem is currently using a RinRuby fork right now that doesn't support windows.

## Installation

Add this line to your application's Gemfile:

    gem 'rin_ruby_helpers', git: 'git://github.com/elbartostrikesagain/rin-ruby-helpers.git'

And then execute:

    $ bundle install

## Dependencies
R must be installed and rinruby must be able to connect to R

## Usage

I highly recommend viewing the specs for usage but here is some documentation:


Install and require RinRuby then include the helpers module on the RinRuby class like so:

```
Class RinRuby
  include RinRubyHelpers
end
```

then you can use the additional helper methods: `linear_regression` and `object_linear_regression`

#### predict from objects:
```
#given an example class that has methods square_feet, acres and price, predict the price of a home for a a given amount of square_feet and arces

class House
  attr_accessor :square_feet, :acres, :price
end

homes = [...] #array of house objects(with known price)
predict_data = [2000, 1.2] #predict a house for 2000 square_feet and 1.2 acres

linear_regression_object = rinruby.object_linear_regression(training_data: homes,
                                                            predict_data: predict,
                                                            features: [:square_feet, :acres],
                                                            predict_method: :price)
rinruby.quit

linear_regression_object.prediction
linear_regression_object.p_value
linear_regression_object.r_squared
linear_regression_object.adjusted_r_squared
linear_regression_object.standard_error
linear_regression_object.fstatistic
linear_regression_object.errors
linear_regression_object.estimates
linear_regression_object.t_values
linear_regression_object.prediction_interval #95%
linear_regression_object.confidence_interval #95%
```

#### predict from arrays:
```
rinruby = RinRuby.new

#first array(s) are features/independent variables, last array are the predictors/dependent variables
training_data = [[1,2,3,4], [2,4,6,8]]
predict_data = [5]

linear_regression_object = rinruby.linear_regression(training_data: training_data, predict_data: predict)

rinruby.quit

linear_regression_object.prediction #=> 10
linear_regression_object.p_value
linear_regression_object.r_squared
linear_regression_object.adjusted_r_squared
linear_regression_object.standard_error
linear_regression_object.fstatistic
linear_regression_object.errors
linear_regression_object.estimates
linear_regression_object.t_values
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
