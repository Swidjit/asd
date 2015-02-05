class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.belongs_to :user
      t.integer :flagged_user, :null=>:false
      t.integer :meal_id, :null=>:false
      t.integer :abused_term, :null=>:false
      t.string :comment
    end
  end
end
