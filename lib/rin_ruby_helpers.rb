require "rin_ruby_helpers/version"
require "rin_ruby_helpers/linear_model"

module RinRubyHelpers

  def linear_regression(training_data:, predict_data:)
    data_frame_names = []
    vector_names = []

    training_data.each_with_index do |td, i|
      vector_name = "vector_#{i}"
      vector_names << vector_name
      data_frame_name = "data_frame_#{i}"
      data_frame_names << data_frame_name

      self.assign vector_name, td
      self.eval "#{data_frame_name} = data.frame(#{vector_name})"
    end

    predict_data_str = predict_data.each_with_index.map{|pd, i| "vector_#{i}=#{pd}"}.join(', ')

    self.eval(%{
      data = cbind(#{data_frame_names.join(',')})
      data.lm = lm(#{vector_names.last} ~ #{vector_names.join(' + ')}, data=data)
      newdata = data.frame(#{predict_data_str})
      fstatistic = summary(data.lm)$fstatistic
    })

    linear_model = LinearModel.new(self, vector_names)
    return linear_model
  end

  def object_linear_regression(training_data:, predict_data:, features:, predict_method:)
    raise "Dimension mismatch on features and predict_data" unless features.length == predict_data.length

    predict_method = [predict_method] unless predict_method.is_a?(Array)
    methods = features + predict_method
    training_data = methods.map{ |method| training_data.map{|td| td.send(method)} }

    linear_model = linear_regression(training_data: training_data, predict_data: predict_data)
    linear_model.features = features

    return linear_model
  end
end
