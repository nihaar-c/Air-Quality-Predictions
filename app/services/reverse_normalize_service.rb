class ReverseNormalizeService
  require 'yaml'

  def initialize
    @normalized_min_max = YAML.load_file("normalized_min_max.yml")
  end

  def unnormalize_aqi(normalized_aqi)
    normalized_column = "AQI_normalized"
    if @normalized_min_max[normalized_column]
      min = @normalized_min_max[normalized_column][:min]
      max = @normalized_min_max[normalized_column][:max]
      range = max - min
      unnormalized_aqi = normalized_aqi * range + min
    else
      raise "Normalization parameters for #{normalized_column} not found"
    end
    unnormalized_aqi
  end
end
