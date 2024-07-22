class CreateAirQualityData < ActiveRecord::Migration[7.1]
  def change
    create_table :air_quality_data do |t|
      t.datetime :date
      t.integer :aqi
      t.string :location

      t.timestamps
    end
  end
end
