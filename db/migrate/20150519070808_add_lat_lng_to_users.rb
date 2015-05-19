class AddLatLngToUsers < ActiveRecord::Migration
  def change
    add_column :users, :latlng, :string
  end
end
