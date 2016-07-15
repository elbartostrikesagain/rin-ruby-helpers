require 'spec_helper'

class RinRuby
 include RinRubyHelpers
end

describe RinRubyHelpers do
  #data from http://stattrek.com/regression/regression-example.aspx?Tutorial=AP
  let(:single_var_training_data) {[
    [95,85,80,70,60],
    [85,95,70,65,70]
  ]}
  let(:single_var_prediction_data) {[90]}

  #data from http://www.r-tutor.com/elementary-statistics/multiple-linear-regression/estimated-multiple-regression-equation
  #(note "stackloss" is sample data that comes with R)
  let(:air_flow)           {[80,80,75,62,62,62,62,62,58,58,58,58,58,58,50,50,50,50,50,56,70]}
  let(:water_temp)         {[27,27,25,24,22,23,24,24,23,18,18,17,18,19,18,18,19,19,20,20,20]}
  let(:acid_concentration) {[89,88,90,87,87,87,93,93,87,80,89,88,82,93,89,86,72,79,80,82,91]}
  let(:stack_loss)         {[42,37,37,28,18,18,19,20,15,14,14,13,11,12, 8, 7, 8, 8, 9,15,15]}
  let(:multi_var_training_data)   {[air_flow, water_temp, acid_concentration, stack_loss]}
  let(:multi_var_prediction_data) {[72, 20, 85]}

  let(:rinruby) {RinRuby.new(false)}

  describe "linear regression prediction" do
    context "single variable" do
      it "returns a prediction value" do
        prediction = rinruby.regression_prediction(training_data: single_var_training_data, predict_data: single_var_prediction_data)
        expect(prediction).to be_within(0.01).of(84.728)
      end
    end

    context "multi variable" do
      it "returns a prediction value" do
        prediction = rinruby.regression_prediction(training_data: multi_var_training_data, predict_data: multi_var_prediction_data)
        expect(prediction).to be_within(0.001).of(24.582)
      end
    end
  end

  describe "linear regression prediction via objects" do
    context "single variable" do
      let!(:test_scores_class){
        class TestScores
          attr_accessor :prelim_test_score, :final_test_score
        end
      }
      let(:test_scores){
        test_scores = []
        single_var_training_data[0].length.times do |i|
          ts = TestScores.new
          ts.prelim_test_score = single_var_training_data[0][i]
          ts.final_test_score = single_var_training_data[1][i]
          test_scores << ts
        end
        test_scores
      }

      it "returns a prediction value based on the specified feature(method)" do
        prediction = rinruby.object_regression_prediction(features: [:prelim_test_score],
                                                    training_data: test_scores,
                                                    predict_data: single_var_prediction_data,
                                                    predict_method: :final_test_score)
        expect(prediction).to be_within(0.01).of(84.728)
      end
    end

    context "multi variable" do
      let!(:stackloss_class){
        class StackLoss
          attr_accessor :air_flow, :water_temp, :acid_concentration, :loss
        end
      }
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

      it "returns a prediction value based on the specified features(methods)" do
        prediction = rinruby.object_regression_prediction(features: [:air_flow, :water_temp, :acid_concentration],
                                                    training_data: stack_losses,
                                                    predict_data: multi_var_prediction_data,
                                                    predict_method: :loss)
      end
    end
  end
end
