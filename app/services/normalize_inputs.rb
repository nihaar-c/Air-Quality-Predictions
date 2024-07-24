require 'yaml'

class NormalizeInputs
  
  def initialize()
    @normalized_min_max = YAML.load_file("normalized_min_max.yml")
  end

  def normalize(temp:, humidity:, wspd:)
    {
      temp: normalize_val(temp, "Temperature_normalized"),
      humidity: normalize_val(humidity, "Humidity_normalized"),
      wspd: normalize_val(wspd, "WindSpeed_normalized")
    }
  end

  def normalize_val(value, normalized_column)
    if normalized_column == "Temperature_normalized"
      # Convert F to Celsius
      value = (value-32) * (5/9)
    end
    if @normalized_min_max[normalized_column]
      min = @normalized_min_max[normalized_column][:min]
      max = @normalized_min_max[normalized_column][:max]
      range = max-min
      (value-min)/range
    else
        raise "Failed to normalize for #{normalized_column}"
    end
  end

end