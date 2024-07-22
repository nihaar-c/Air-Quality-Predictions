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
      df = normalize_data(df)
      
      # Store the cleaned data in the database
      store_data(df)
    end
  
    private
  
    def handle_missing_values(df)
      # Example: Fill missing values with the mean of the column
      df.vectors.each do |vector|
        mean = df[vector].mean
        df[vector] = df[vector].map { |v| v.nil? ? mean : v }
      end
      df
    end
  
    def normalize_data(df)
      # Example: Normalize data to a 0-1 range
      df.vectors.each do |vector|
        min = df[vector].min
        max = df[vector].max
        df[vector] = df[vector].map { |v| (v - min) / (max - min).to_f }
      end
      df
    end
  
    def store_data(df)
      df.each_row do |row|
        AirQualityDatum.create(
          aqi: row['AQI'],
          temp: row['Temperature'],
          humidity: row['Humidity'],
          wspd: row['WindSpeed']
        )
      end
    end
  end
  