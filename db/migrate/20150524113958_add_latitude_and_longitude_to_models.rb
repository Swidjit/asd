class AddLatitudeAndLongitudeToModels < ActiveRecord::Migration
  def change
    add_column :listings, :latitude, :float
    add_column :listings, :longitude, :float
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
    remove_column :users, :latlng
    remove_column :listings, :latlng

  end
end
