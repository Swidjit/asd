class AddModeToMeals < ActiveRecord::Migration
  def change
    add_column :meals, :visibility, :string, :default => "public"
  end
end
