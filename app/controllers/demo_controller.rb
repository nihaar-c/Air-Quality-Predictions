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

    url = URI.parse('https://api.waqi.info/feed/%s/?token=6d9886a72b49a7a89b867879513035742386311d' % [city])
    response = Net::HTTP.get(url)
    data = JSON.parse(response)

    wind = data['data']['iaqi']['w']['v']
    temp = data['data']['iaqi']['t']['v']
    humidity = data['data']['iaqi']['h']['v']
    actual_aqi = data['data']['aqi']

    render json: { predicted: 100, actual: actual_aqi}
  end
end
