require "logger"

TRAINING_LOGGER = Logger.new(Rails.root.join('log', 'training.log'))
TRAINING_LOGGER.level = Logger::DEBUG
TRAINING_LOGGER.formatter = Logger::Formatter.new