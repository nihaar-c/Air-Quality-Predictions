class PredictController < ApplicationController
  protect_from_forgery with: :null_session
  def index
  end
  def create
    data = JSON.parse(request.body.read)

    temp = data['temp']
    speed = data['speed']
    temp = data['temp']


    render json: { aqi: 100 }
  end
end
