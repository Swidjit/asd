class AddImageToMeals < ActiveRecord::Migration
  def self.up
    add_attachment :meals, :pic
  end

  def self.down
    remove_attachment :meals, :pic
  end
end
