class AddRsvpCountToMeals < ActiveRecord::Migration
  def change
    add_column :meals, :rsvps_count, :integer, :default => 0
  end
end
