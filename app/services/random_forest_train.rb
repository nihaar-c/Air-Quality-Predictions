require 'rumale'

class RandomForestTrain
  def initialize(split_data)
    @x_train = split_data[:x_train]
    @y_train = split_data[:y_train]
    @x_test = split_data[:x_test]
    @y_test = split_data[:y_test]
  end

  def train_model
    model = Rumale::Ensemble::RandomForestRegressor.new(n_estimators: 100, max_depth: 3)
    model.fit(@x_train, @y_train)
    model
  end
end
