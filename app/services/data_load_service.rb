require 'daru'

class DataLoadService
  def load_data
    data = AirQualityDatum.all
    data_array = data.map { |datum| [datum.aqi, datum.temp, datum.humidity, datum.wspd] }
    Daru::DataFrame.rows(data_array, order: [:aqi, :temp, :humidity, :wspd])
  end
end
