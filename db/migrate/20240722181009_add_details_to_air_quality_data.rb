class AddDetailsToAirQualityData < ActiveRecord::Migration[7.1]
  def change
    add_column :air_quality_data, :temp, :float
    add_column :air_quality_data, :humidity, :float
    add_column :air_quality_data, :wspd, :float
  end
end
