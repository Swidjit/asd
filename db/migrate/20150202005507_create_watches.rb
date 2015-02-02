class CreateWatches < ActiveRecord::Migration
  def change
    create_table :watches do |t|
      t.belongs_to :meal
      t.belongs_to :user
    end
  end
end
