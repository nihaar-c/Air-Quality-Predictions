require 'rumale'

class ElasticNetTrain
  def initialize(split_data)
    @x_train = split_data[:x_train]
    @y_train = split_data[:y_train]
    @x_test = split_data[:x_test]
    @y_test = split_data[:y_test]
  end

  def train_model
    model = Rumale::LinearModel::ElasticNet.new(
      reg_param: 1.0,
      l1_ratio: 0.5,
      max_iter: 1000,
      tol: 1e-4
    )
    model.fit(@x_train, @y_train)
    model
  end
end
