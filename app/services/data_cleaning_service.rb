class DataCleaningService
    require 'daru'
    require 'csv'
  
    def initialize(dataset_path)
      @dataset_path = dataset_path
    end
  
    def clean_and_store_data
      data = []
      headers = []
      CSV.foreach(@dataset_path, headers: true) do |row|
        data << row.to_h
        headers = row.headers if headers.empty?
      end
  
      df = Daru::DataFrame.new(data, order: headers)
  
      # Clean and preprocess the data
      df = handle_missing_values(df)
      df, normalized_min_max = normalize_data(df)

      df.each_row do |row|
        puts "Normalized values: AQI: #{row['AQI']}, Temp: #{row['Temperature']}, Humidity: #{row['Humidity']}, Wind Speed: #{row['WindSpeed']}"
      end

      # Store the cleaned data in the database
      store_data(df)

      save_normalization_params(normalized_min_max)
    end
  
    private
  
    def handle_missing_values(df)
      # Example: Fill missing values with the mean of the column
      df.vectors.each do |vector|
        non_nil_values = df[vector].reject(&:nil?).map(&:to_f)
        mean = non_nil_values.sum / non_nil_values.size
        df[vector] = df[vector].map { |v| v.nil? ? mean : v.to_f }
      end
      df
    end
  
    def normalize_data(df)
        normalized_min_max = {}
    
        df.vectors.each do |vector|
          values = df[vector].map(&:to_f)
          min = values.min
          max = values.max
          range = max - min
    
          # Create new column for normalized values
          normalized_column = "#{vector}_normalized"
          df[normalized_column] = values.map { |v| (v - min) / range }
    
          # Store min and max values for later use
          normalized_min_max[normalized_column] = { min: min, max: max }
        end
    
        return df, normalized_min_max
    end
  
    def store_data(df)
      df.each_row do |row|
        AirQualityDatum.create(
          aqi: row['AQI_normalized'],
          temp: row['Temperature_normalized'],
          humidity: row['Humidity_normalized'],
          wspd: row['WindSpeed_normalized']
        )
      end
    end

    def save_normalization_params(normalized_min_max)
      File.open("normalized_min_max.yml", "w") {
        |file| file.write(normalized_min_max.to_yaml)
      }
    end
  end
  