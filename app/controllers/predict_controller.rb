class PredictController < ApplicationController
  protect_from_forgery with: :null_session
  def index
  end
  def create
    data = JSON.parse(request.body.read)

    temp = data['temp']
    humidity = data['humidity']
    speed = data['speed']


    render json: { aqi: 100 }
  end
end
