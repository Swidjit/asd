class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.belongs_to :user
      t.string :title, :null=>:false
      t.string :description
      t.string :address, :null=>:false
      t.integer :price, :null=>:false
      t.integer :noi, :null=>:false
      t.float :cap_rate
      t.integer :arv
      t.string :property_type
      t.string :city
      t.string :country
      t.integer :zip_code
      t.integer :units
      t.string :status

      t.timestamps
    end
  end
end
