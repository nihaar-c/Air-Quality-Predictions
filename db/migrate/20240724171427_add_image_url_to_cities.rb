class AddImageUrlToCities < ActiveRecord::Migration[7.1]
  def change
    add_column :cities, :image_url, :string
  end
end
