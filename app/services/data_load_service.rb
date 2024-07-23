require 'daru'

class DataLoadService
  def load_data(filename = nil)
    if filename
      data = AirQualityDatum.all
      data_array = data.map { |datum| [datum.aqi, datum.temp, datum.humidity, datum.wspd] }
      Daru::DataFrame.rows(data_array, order: [:aqi, :temp, :humidity, :wspd])
    else
      hardcoded_data
    end
  end

  def hardcoded_data
    data_array = [
      {temp: 0.3221, humidity: 0.8314, wspd: 0.533}
    ]

    Daru::DataFrame.rows(data_array, order: [:temp, :humidity, :wspd])
  end
end
