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

    input_data = { temp: 96, humidity: 25, wspd: 10}
    normal = NormalizeInputs.new
    normalized_inputs = normal.normalize(temp: input_data[:temp], humidity: input_data[:humidity], wspd: input_data[:wspd])
    puts "3"
    #Predict
    prediction_data = Numo::DFloat[normalized_inputs.values].reshape(1, normalized_inputs.values.size)
    predictions = PredictionService.new(model, prediction_data).make_predictions

    normalized_aqi = predictions[0]
    unnormalize = ReverseNormalizeService.new
    reverted_aqi = unnormalize.unnormalize_aqi(normalized_aqi)
    puts reverted_aqi

    #Log
    PREDICTION_LOGGER.info("Predictions: #{predictions.inspect}")
    PREDICTION_LOGGER.info("Predictions: #{(predictions[-1]*500).inspect}")

  end
end