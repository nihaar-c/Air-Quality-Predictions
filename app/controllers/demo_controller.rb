require 'json'
require 'net/http'

class DemoController < ApplicationController
  protect_from_forgery with: :null_session
  def index
    @cities = City.all
  end
  def create
    data = JSON.parse(request.body.read)
    city = data['city'].gsub(' ', '%20')

    uri = URI('https://api.waqi.info/feed/%s/' % [city])
    params = {
      :token => '6d9886a72b49a7a89b867879513035742386311d',
    }
    uri.query = URI.encode_www_form(params)

    req = Net::HTTP::Get.new(uri)
    req['accept'] = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7'
    req['accept-language'] = 'en-US,en;q=0.9'
    req['cache-control'] = 'max-age=0'
    req['priority'] = 'u=0, i'
    req['sec-ch-ua'] = '"Not/A)Brand";v="8", "Chromium";v="126", "Google Chrome";v="126"'
    req['sec-ch-ua-mobile'] = '?0'
    req['sec-ch-ua-platform'] = '"macOS"'
    req['sec-fetch-dest'] = 'document'
    req['sec-fetch-mode'] = 'navigate'
    req['sec-fetch-site'] = 'none'
    req['sec-fetch-user'] = '?1'
    req['upgrade-insecure-requests'] = '1'
    req['user-agent'] = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36'

    req_options = {
      use_ssl: uri.scheme == 'https'
    }
    res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(req)
    end

    data = JSON.parse(res.body)

    wind = data['data']['iaqi']['w']['v']
    temp = data['data']['iaqi']['t']['v']
    humidity = data['data']['iaqi']['h']['v']
    actual_aqi = data['data']['aqi']

    puts "1"
    #Load model
    model_load_service = ModelLoadService.new("temp_forest_model.dat")
    model = model_load_service.load_model

    puts "2"
    #Load and normalize data
    input_data = { temp: temp, humidity: humidity, wspd: wind}
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
    

    render json: { predicted: (predictions[0]*500).to_i, actual: actual_aqi}
  end
end
