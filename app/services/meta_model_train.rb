require 'rumale'

# class MetaModelTrain
#   def initialize(split_data)
#     @x_train = split_data[:x_train]
#     @y_train = split_data[:y_train]
#     @x_test = split_data[:x_test]
#     @y_test = split_data[:y_test]  end

#   def train_model
#     forest_model = Rumale::Ensemble::RandomForestRegressor.new(n_estimators: 100, max_depth: 3)
#     forest_model.fit(@x_train, @y_train)

#     rf_predictions = forest_model.predict(@x_train).reshape(@x_train.shape[0], 1)
#     #rf_predictions = rf_predictions.reshape(rf_predictions.size, 1)
#     enhanced_features = @x_train.concatenate(rf_predictions, axis: 1)

#     # Define and train the Neural Network
#     net = Rumale::NeuralNetwork::MLPRegressor.new(hidden_units: [64, 32], learning_rate: 0.01, max_iter: 200)
#     net.fit(enhanced_features, @y_train)

#     nn_predictions = net.predict(enhanced_features).reshape(enhanced_features.shape[0], 1)
#     #nn_predictions = nn_predictions.reshape(nn_predictions.size, 1)


#     puts "raeched regression"

#     # Use a simple Linear Regression as the meta-model
#     meta_features = Numo::DFloat.hstack([rf_predictions, nn_predictions])
#     puts "regression 1"
#     meta_model = Rumale::LinearModel::LinearRegression.new
#     puts "regression 2"
#     meta_model.fit(meta_features, @y_train)
#     puts "regression 3"
#     meta_model

#   end
# end

class MetaModelTrain
  def initialize(split_data)
    @x_train = split_data[:x_train]
    @y_train = split_data[:y_train]
    @x_test = split_data[:x_test]
    @y_test = split_data[:y_test]
  end

  def train_model
    # Train Random Forest
    forest_model = Rumale::Ensemble::RandomForestRegressor.new(n_estimators: 100, max_depth: 3)
    forest_model.fit(@x_train, @y_train)

    # Get predictions from Random Forest
    rf_predictions_train = forest_model.predict(@x_train).reshape(@x_train.shape[0], 1)
    rf_predictions_test = forest_model.predict(@x_test).reshape(@x_test.shape[0], 1)
    puts "Shape of rf_predictions_train: #{rf_predictions_train.shape}"
    puts "Shape of rf_predictions_test: #{rf_predictions_test.shape}"

    # Prepare enhanced features for Neural Network
    enhanced_features_train = @x_train.concatenate(rf_predictions_train, axis: 1)
    enhanced_features_test = @x_test.concatenate(rf_predictions_test, axis: 1)
    puts "Shape of enhanced_features_train: #{enhanced_features_train.shape}"
    puts "Shape of enhanced_features_test: #{enhanced_features_test.shape}"

    # Define and train the Neural Network
    net = Rumale::NeuralNetwork::MLPRegressor.new(hidden_units: [64, 32], learning_rate: 0.01, max_iter: 200)
    net.fit(enhanced_features_train, @y_train)

    # Get predictions from Neural Network
    nn_predictions_train = net.predict(enhanced_features_train).reshape(enhanced_features_train.shape[0], 1)
    nn_predictions_test = net.predict(enhanced_features_test).reshape(enhanced_features_test.shape[0], 1)
    puts "Shape of nn_predictions_train: #{nn_predictions_train.shape}"
    puts "Shape of nn_predictions_test: #{nn_predictions_test.shape}"

    # Combine predictions for meta-model
    meta_features_train = Numo::DFloat.hstack([rf_predictions_train, nn_predictions_train])
    meta_features_test = Numo::DFloat.hstack([rf_predictions_test, nn_predictions_test])
    puts "Shape of meta_features_train: #{meta_features_train.shape}"
    puts "Shape of meta_features_test: #{meta_features_test.shape}"

    # Train Linear Regression as meta-model
    meta_model = Rumale::LinearModel::LinearRegression.new
    meta_model.fit(meta_features_train, @y_train)

    # Evaluate the model
    evaluation = evaluate_model(meta_model, meta_features_test, @y_test)
    puts evaluation

  end

  private

  def evaluate_model(model, x_test, y_test)
    predictions = model.predict(x_test)
    mse = Rumale::EvaluationMeasure::MeanSquaredError.new
    r2 = Rumale::EvaluationMeasure::R2Score.new
    mape = Rumale::EvaluationMeasure::MeanAbsoluteError.new

    {
      mse: mse.score(y_test, predictions),
      r2: r2.score(y_test, predictions),
      mape: mape.score(y_test, predictions)
    }
  end
end

