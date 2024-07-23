namespace :model do
  task :predict, [:model_filename] => :environment do |t, args|
    
    puts "1"
    #Load model
    model_load_service = ModelLoadService.new(args[:model_filename])
    model = model_load_service.load_model

    puts "2"
    #Load data
    #data_load_service = DataLoadService.new
    #prediction_data = data_load_service.load_data

    prediction_data = Numo::DFloat[[1.76, 0.16, 0.5]]
    puts "3"
    #Predict
    predictions = PredictionService.new(model, prediction_data).make_predictions

    normalized_aqi = predictions[0]
    unnormalize = ReverseNormalizeService.new
    reverted_aqi = unnormalize.unnormalize_aqi(normalized_aqi)
    puts reverted_aqi

    #Log
    PREDICTION_LOGGER.info("Predictions: #{predictions.inspect}")
    PREDICTION_LOGGER.info("Predictions: #{(predictions[0]*500).inspect}")

  end
end