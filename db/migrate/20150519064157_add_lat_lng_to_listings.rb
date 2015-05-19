class AddLatLngToListings < ActiveRecord::Migration
  def change
    add_column :listings, :latlng, :string
  end
end
