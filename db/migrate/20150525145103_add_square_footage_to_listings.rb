class AddSquareFootageToListings < ActiveRecord::Migration
  def change
    add_column :listings, :square_footage, :integer
  end
end
