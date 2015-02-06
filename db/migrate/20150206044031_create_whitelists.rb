class CreateWhitelists < ActiveRecord::Migration
  def change
    create_table :whitelists do |t|
      t.integer :whitelisted_user_id,:null=>:false
      t.belongs_to :user
    end
  end
end
