class ModifyDealSize < ActiveRecord::Migration
  def change

    add_column :users, :min_deal, :integer, :null => :false
    add_column :users, :max_deal, :integer, :null => :false

  end
end
