class PredictController < ApplicationController
  protect_from_forgery with: :null_session
  def index
  end
  def create
    data = JSON.parse(request.body.read)

    temp = data['temp'].to_f
    humidity = data['humidity'].to_f
    speed = data['speed'].to_f

    puts "1"
    #Load model
    model_load_service = ModelLoadService.new("random_forest_model.dat")
    model = model_load_service.load_model

    puts "2"
    #Load and normalize data
    input_data = { temp: temp, humidity: humidity, wspd: speed}
    normal = NormalizeInputs.new
    normalized_inputs = normal.normalize(temp: input_data[:temp], humidity: input_data[:humidity], wspd: input_data[:wspd])

    # prediction_data = Numo::DFloat[[temp, humidity, speed]]

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
    PREDICTION_LOGGER.info("Predictions: #{(predictions[0]*500).inspect}")

    render json: { aqi: (predictions[0]*500).to_i }
  end
end
