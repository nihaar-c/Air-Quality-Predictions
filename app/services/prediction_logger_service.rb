class PredictionLoggerService
  def initialize(predictions)
    @predictions = predictions
  end

  def log_predictions
    PREDICTION_LOGGER.info("Predictions: #{@predictions}")
  end
end