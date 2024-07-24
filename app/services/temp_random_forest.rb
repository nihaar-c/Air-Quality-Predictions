class TempRandomForest
  def initialize(data)
    @x_train = data[:x_train]
    @y_train = data[:y_train]
    @x_test = data[:x_test]
    @y_test = data[:y_test]
  end

  def train_model
    best_model = nil
    best_mse = Float::INFINITY

    # Define hyperparameters to tune
    n_estimators_list = [100, 200, 300]
    max_depth_list = [3, 5, 7]

    # Grid search for the best hyperparameters
    n_estimators_list.each do |n_estimators|
      max_depth_list.each do |max_depth|
        model = Rumale::Ensemble::RandomForestRegressor.new(
          n_estimators: n_estimators,
          max_depth: max_depth
        )
        model.fit(@x_train, @y_train)
        predictions = model.predict(@x_test)
        mse = mean_squared_error(@y_test, predictions)
        if mse < best_mse
          best_mse = mse
          best_model = model
        end
      end
    end

    best_model
  end

  private

  def mean_squared_error(y_true, y_pred)
    ((y_true - y_pred)**2).mean
  end
end
