require "logger"

PREDICTION_LOGGER = Logger.new(Rails.root.join('log', 'prediction.log'))
PREDICTION_LOGGER.level = Logger::DEBUG
PREDICTION_LOGGER.formatter = Logger::Formatter.new