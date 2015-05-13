class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string,:null => false
    add_column :users, :last_name, :string,:null => false
    add_column :users, :username, :string, :null => :false
    add_column :users, :about, :string

    add_column :users, :address, :string
    add_column :users, :city, :string
    add_column :users, :county, :string

    add_column :users, :property_type, :string
    add_column :users, :deal_size, :string

    add_column :users, :tokens, :integer

  end
end
