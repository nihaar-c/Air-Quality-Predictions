namespace :dataset do
    desc "Load air quality dataset"
    task load: :environment do
      require 'daru'
      require 'csv'
  
      dataset_path = Rails.root.join('data', 'air_quality','air_quality_health_impact_data.csv')
  
      # Read the CSV file
      data = []
      headers = []
      CSV.foreach(dataset_path, headers: true) do |row|
        data << row.to_h
        headers = row.headers if headers.empty?
      end
  
      # Create a Daru::DataFrame from the parsed data
      df = Daru::DataFrame.new(data, order: headers)
  
      # Insert data into the database
      df.each_row do |row|
        AirQualityDatum.create(
            aqi: row['AQI'],
            temp: row['Temperature'],
            humidity: row['Humidity'],
            wspd: row['WindSpeed']
        )
      end
  
      puts "Dataset loaded successfully."
    end
  end
  
  
namespace :dataset do
    desc "Load and clean air quality dataset"
    task load_and_clean: :environment do
      dataset_path = Rails.root.join('data', 'air_quality', 'air_quality_health_impact_data.csv')
      service = DataCleaningService.new(dataset_path)
      service.clean_and_store_data
      puts "Dataset loaded and cleaned successfully."
    end
  end