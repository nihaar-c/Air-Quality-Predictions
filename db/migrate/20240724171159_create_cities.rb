class CreateCities < ActiveRecord::Migration[7.1]
  def change
    create_table :cities do |t|
      t.string :name
      t.string :state
      t.integer :population_estimate
      t.integer :population_census

      t.timestamps
    end
  end
end
