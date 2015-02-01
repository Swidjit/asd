class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.belongs_to :user
      t.string :title, :null=>:false
      t.string :description
      t.datetime :start_time, :null=>:false
      t.datetime :end_time
      t.string :address, :null=>:false
      t.integer :cost, :null=>:false
      t.integer :dine_in_count, :null=>:false
      t.integer :take_out_count, :default => 0

      t.timestamps
    end
  end
end
