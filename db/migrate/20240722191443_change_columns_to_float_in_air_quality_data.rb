class ChangeColumnsToFloatInAirQualityData < ActiveRecord::Migration[7.1]
  def change
    change_column :air_quality_data, :aqi, :float
    change_column :air_quality_data, :temp, :float
    change_column :air_quality_data, :humidity, :float
    change_column :air_quality_data, :wspd, :float
  end
end
