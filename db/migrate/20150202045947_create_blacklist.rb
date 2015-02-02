class CreateBlacklist < ActiveRecord::Migration
  def change
    create_table :blacklists do |t|
      t.integer :blacklisted_user_id,:null=>:false
      t.belongs_to :user
    end
  end
end
