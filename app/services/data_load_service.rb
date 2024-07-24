require 'daru'

class DataLoadService
  def load_data
    # if filename
    data = AirQualityDatum.all
    data_array = data.map { |datum| [datum.aqi, datum.temp, datum.humidity, datum.wspd] }
    # data_array.each do |row|
    #   puts "Normalized values: AQI: #{row[0]}, Temp: #{row[1]}, Humidity: #{row[2]}, Wind Speed: #{row[3]}"
    # end
    Daru::DataFrame.rows(data_array, order: [:aqi, :temp, :humidity, :wspd])
    # else
    #   hardcoded_data
    # end
  end

  def hardcoded_data
    data_array = [
      {temp: 0.3221, humidity: 0.8314, wspd: 0.533}
    ]

    Daru::DataFrame.rows(data_array, order: [:temp, :humidity, :wspd])
  end
end
