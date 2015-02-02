class CreateRsvps < ActiveRecord::Migration
  def change
    create_table :rsvps do |t|
      t.belongs_to :meal
      t.belongs_to :user
    end
  end
end
