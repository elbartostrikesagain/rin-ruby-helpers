require "rin_ruby_helpers/version"

module RinRubyHelpers
  #training_data: [ [100,150,200], [1,2,3], [200,300,500] ]
  def regression_prediction(training_data:, predict_data:)
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
      prediction = predict(data.lm, newdata)
    })

    self.eval("newdata")

    return self.pull("prediction")
  end


  def object_regression_prediction(training_data:, predict_data:, features:, predict_method:)
    raise "Dimension mismatch on features and predict_data" unless features.length == predict_data.length

    predict_method = [predict_method] unless predict_method.is_a?(Array)
    methods = features + predict_method
    training_data = methods.map{ |method| training_data.map{|td| td.send(method)} }

    regression_prediction(training_data: training_data, predict_data: predict_data)
  end
end
