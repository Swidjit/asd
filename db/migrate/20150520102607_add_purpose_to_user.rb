class AddPurposeToUser < ActiveRecord::Migration
  def change
    add_column :users, :purpose, :string, :null=>:false
  end
end
