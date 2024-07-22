class CreateAirQualityData < ActiveRecord::Migration[7.1]
  def change
    create_table :air_quality_data do |t|
      t.float :aqi
      t.float :temp
      t.float :humidity
      t.float :wspd

      t.timestamps
    end
  end
end
