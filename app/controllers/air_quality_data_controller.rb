class AirQualityDataController < ApplicationController
  def index
    @air_quality_data = AirQualityDatum.all
  end
end
