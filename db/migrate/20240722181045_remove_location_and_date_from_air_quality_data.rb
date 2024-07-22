class RemoveLocationAndDateFromAirQualityData < ActiveRecord::Migration[7.1]
  def change
    remove_column :air_quality_data, :location, :string
    remove_column :air_quality_data, :date, :datetime
  end
end
