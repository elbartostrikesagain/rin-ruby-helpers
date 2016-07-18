module RinRubyHelpers
  class LinearModel
    attr_reader :prediction, :adjusted_r_squared, :r_squared, :standard_error, :fstatistic, :p_value
    attr_accessor :features

    def initialize(r, methods)
      @features = methods[0..(methods.length-2)]

      @prediction = r.pull("predict(data.lm, newdata)")
      @lower_confidence = r.pull("predict(data.lm, newdata, interval='confidence')[2]")
      @upper_confidence = r.pull("predict(data.lm, newdata, interval='confidence')[3]")
      @lower_prediction = r.pull("predict(data.lm, newdata, interval='predict')[2]")
      @upper_prediction = r.pull("predict(data.lm, newdata, interval='predict')[3]")

      @errors = r.pull("summary(data.lm)$coefficients[,'Std. Error']")
      @estimates = r.pull("summary(data.lm)$coefficients[,'Estimate']")
      @t_values = r.pull("summary(data.lm)$coefficients[,'t value']")
      @adjusted_r_squared = r.pull("summary(data.lm)$adj.r.squared")
      @r_squared = r.pull("summary(data.lm)$r.squared")
      @standard_error = r.pull("summary(data.lm)$sigma")
      @fstatistic = r.pull("fstatistic")
      @p_value = r.pull("pf(fstatistic[1],fstatistic[2],fstatistic[3],lower.tail=F)")
    end

    def prediction_interval #95%
      [@lower_prediction, @upper_prediction]
    end

    def confidence_interval #95%
      [@lower_confidence, @upper_confidence]
    end

    def errors
      values_as_feature_hash(@errors)
    end

    def estimates
      values_as_feature_hash(@estimates)
    end

    def t_values
      values_as_feature_hash(@t_values)
    end

    private
    def values_as_feature_hash(values)
      {y_intercept: values[0]}.merge(Hash[features.zip(values[1..(values.length-1)])])
    end
  end
end
