require 'rumale'
require 'xgboost'

class XGBoostTrain
  def initialize(split_data)
    @x_train = split_data[:x_train]
    @y_train = split_data[:y_train]
    @x_test = split_data[:x_test]
    @y_test = split_data[:y_test]
  end

  def train_model
    model = XGBoost::Regressor.new
    model.fit(@x_train, @y_train)
    model
  end
end
