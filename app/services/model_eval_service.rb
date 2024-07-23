class ModelEvalService
  def initialize(model, data)
    @model = model
    @data = data
  end

  def evaluate_model
    predictions = @model.predict(@data[:x_test])

    mse = Rumale::EvaluationMeasure::MeanSquaredError.new
    mae = Rumale::EvaluationMeasure::MeanAbsoluteError.new
    r2 = Rumale::EvaluationMeasure::R2Score.new
    mape = mean_absolute_percentage_error(@data[:y_test], predictions)

    error_mse = mse.score(@data[:y_test], predictions)
    error_mae = mae.score(@data[:y_test], predictions)
    error_r2 = r2.score(@data[:y_test], predictions)
    error_mape = mape


    { predictions: predictions, mse: error_mse, mae: error_mae, r2: error_r2, mape: error_mape }

    TRAINING_LOGGER.info "------------- NEW TRAINING -------------"
    TRAINING_LOGGER.info "Linear Regression Model Evaluation Metrics:"
    TRAINING_LOGGER.info "Mean Squared Error: #{error_mse}"
    TRAINING_LOGGER.info "Mean Absolute Error: #{error_mse}"
    TRAINING_LOGGER.info "R-squared: #{error_r2}"
    TRAINING_LOGGER.info "Mean Absolute Percentage Error: #{error_mape}"

  end
  
  private

  def mean_absolute_percentage_error(y_true, y_pred)
    ((y_true-y_pred).abs / y_true.abs).mean * 100
  end
end
