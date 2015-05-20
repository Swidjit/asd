class AddPicToUsers < ActiveRecord::Migration
  def self.up
    add_attachment :users, :pic
  end

  def self.down
    remove_attachment :users, :pic
  end
end
