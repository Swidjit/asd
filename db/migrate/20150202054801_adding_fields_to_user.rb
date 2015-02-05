class AddingFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :address, :string
    add_column :users, :credits, :integer
    add_column :users, :last_name, :string
  end
end
