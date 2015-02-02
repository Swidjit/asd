class CreateDishes < ActiveRecord::Migration
  def change
    create_table :dishes do |t|
      t.string :title
      t.string :description
      t.belongs_to :meal
    end
  end
end
