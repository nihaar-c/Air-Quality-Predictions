require 'rumale'

class MlpNetTrain
  def initialize(split_data)
    @x_train = split_data[:x_train]
    @y_train = split_data[:y_train]
    @x_test = split_data[:x_test]
    @y_test = split_data[:y_test]
  end

  def train_model
    model = Rumale::NeuralNetwork::MLPRegressor.new(hidden_units: [50, 50], learning_rate: 0.01, max_iter: 500)
    model.fit(@x_train, @y_train)
    model
  end
end
