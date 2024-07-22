class AddDetailsToAirQualityData < ActiveRecord::Migration[7.1]
  def change
    add_column :air_quality_data, :temp, :integer
    add_column :air_quality_data, :humidity, :integer
    add_column :air_quality_data, :wspd, :integer
  end
end
