class CreateAirQualityData < ActiveRecord::Migration[7.1]
  def change
    create_table :air_quality_data do |t|
      t.integer :aqi
      t.integer :temp
      t.integer :humidity
      t.integer :wspd

      t.timestamps
    end
  end
end
