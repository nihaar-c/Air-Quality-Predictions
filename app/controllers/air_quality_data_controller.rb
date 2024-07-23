class AirQualityDataController < ApplicationController
  def index
    @air_quality_data = AirQualityDatum.all
    @air_quality_data.each do |datum|
      Rails.logger.info "Datum - AQI: #{datum.aqi}, Temp: #{datum.temp}, Humidity: #{datum.humidity}, Wind Speed: #{datum.wspd}"
    end
  end
  def random
    random_entry = AirQualityDatum.order("RANDOM()").first
    render json: random_entry
  end
end
