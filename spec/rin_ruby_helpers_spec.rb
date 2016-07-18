require 'spec_helper'
require 'csv'

#add helpers to RinRuby
class RinRuby
 include RinRubyHelpers
end

#helper classes used in tests
class Faithful
  attr_accessor :waiting, :eruptions
end
class StackLoss
  attr_accessor :air_flow, :water_temp, :acid_concentration, :loss
end

describe RinRubyHelpers do
  #data from R datasets - "faithful" and "stackloss"
  before(:all) do
    faithful_data = CSV.read("spec/fixtures/faithful.csv", "r")
    @eruptions = faithful_data.map{|c| c[1].to_f}
    @waiting = faithful_data.map{|c| c[2].to_i}

    stackloss_data = CSV.read("spec/fixtures/stackloss.csv", "r")
    @air_flow = stackloss_data.map{|c| c[1].to_i}
    @water_temp = stackloss_data.map{|c| c[2].to_i}
    @acid_concentration = stackloss_data.map{|c| c[3].to_i}
    @stack_loss = stackloss_data.map{|c| c[4].to_i}
  end

  #http://www.r-tutor.com/elementary-statistics/simple-linear-regression/estimated-simple-regression-equation
  let(:eruptions) {@eruptions}
  let(:waiting)   {@waiting}
  let(:single_var_training_data)   {[waiting, eruptions]}
  let(:single_var_prediction_data) {[80]}

  #http://www.r-tutor.com/elementary-statistics/multiple-linear-regression/estimated-multiple-regression-equation
  let(:air_flow)           {@air_flow}
  let(:water_temp)         {@water_temp}
  let(:acid_concentration) {@acid_concentration}
  let(:stack_loss)         {@stack_loss}
  let(:multi_var_training_data)   {[air_flow, water_temp, acid_concentration, stack_loss]}
  let(:multi_var_prediction_data) {[72, 20, 85]}

  let(:rinruby) {RinRuby.new(false)}

  describe "linear regression prediction via arrays" do
    context "single variable" do
      it "returns a linear regression model with prediction" do
        lm = rinruby.linear_regression(training_data: single_var_training_data, predict_data: single_var_prediction_data)
        expect(lm.prediction).to be_within(0.0001).of(4.1762)
      end
    end

    context "multi variable" do
      it "returns a linear regression model with prediction" do
        lm = rinruby.linear_regression(training_data: multi_var_training_data, predict_data: multi_var_prediction_data)
        expect(lm.prediction).to be_within(0.001).of(24.582)
      end
    end
  end

  describe "linear regression prediction via objects" do
    context "single variable" do
      let(:faithfuls){
        faithfuls = []
        single_var_training_data[0].length.times do |i|
          f = Faithful.new
          f.waiting = waiting[i]
          f.eruptions = eruptions[i]
          faithfuls << f
        end
        faithfuls
      }

      it "returns a linear regression model with prediction value based on the specified feature(method)" do
        lm = rinruby.object_linear_regression(features: [:waiting],
                                                    training_data: faithfuls,
                                                    predict_data: single_var_prediction_data,
                                                    predict_method: :eruptions)
        expect(lm.prediction).to be_within(0.0001).of(4.1762)
      end
    end

    context "multi variable" do
      let(:stack_losses){
        stack_losses = []
        air_flow.length.times do |i|
          sl = StackLoss.new
          sl.air_flow = air_flow[i]
          sl.water_temp = water_temp[i]
          sl.acid_concentration = acid_concentration[i]
          sl.loss = stack_loss[i]
          stack_losses << sl
        end
        stack_losses
      }

      it "returns a linear regression model with linear regression info based on the specified features(methods)" do
        lm = rinruby.object_linear_regression(features: [:air_flow, :water_temp, :acid_concentration],
                                                    training_data: stack_losses,
                                                    predict_data: multi_var_prediction_data,
                                                    predict_method: :loss)
        expect(lm.prediction).to be_within(0.001).of(24.582)
        expect(lm.r_squared).to be_within(0.0001).of(0.9136)
        expect(lm.adjusted_r_squared).to be_within(0.0001).of(0.8983)
        expect(lm.p_value).to be_within(0.000000000001).of(0.000000003016)
        expect(lm.standard_error).to be_within(0.000001).of(3.243364)
        expect(lm.fstatistic[0]).to be_within(0.00001).of(59.90223)
        expect(lm.fstatistic[1]).to eq(3.0)
        expect(lm.fstatistic[2]).to eq(17.0)

        expect(lm.errors[:y_intercept]).to be_within(0.0001).of(11.8959)
        expect(lm.errors[:air_flow]).to be_within(0.0001).of(0.1348)
        expect(lm.errors[:water_temp]).to be_within(0.0001).of(0.3680)
        expect(lm.errors[:acid_concentration]).to be_within(0.0001).of(0.1562)

        expect(lm.prediction_interval.first).to be_within(0.0001).of(16.4661)
        expect(lm.prediction_interval.last).to be_within(0.00001).of(32.69736)

        expect(lm.confidence_interval.first).to be_within(0.00001).of(20.21846)
        expect(lm.confidence_interval.last).to be_within(0.001).of(28.945)

        expect(lm.estimates[:y_intercept]).to be_within(0.0001).of(-39.9196)
        expect(lm.estimates[:air_flow]).to be_within(0.0001).of(0.7156)
        expect(lm.estimates[:water_temp]).to be_within(0.0001).of(1.2952)
        expect(lm.estimates[:acid_concentration]).to be_within(0.0001).of(-0.1521)

        expect(lm.t_values[:y_intercept]).to be_within(0.0001).of(-3.3557)
        expect(lm.t_values[:air_flow]).to be_within(0.0001).of(5.3066)
        expect(lm.t_values[:water_temp]).to be_within(0.0001).of(3.5195)
        expect(lm.t_values[:acid_concentration]).to be_within(0.0001).of(-0.9733)
      end
    end
  end
end
