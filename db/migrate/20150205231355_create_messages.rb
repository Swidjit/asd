class CreateMessages < ActiveRecord::Migration
 def change
    create_table :messages do |t|
      t.integer :user_id, :null => false
      t.string :body
      t.belongs_to :user
      t.belongs_to :conversation
      t.timestamps
    end
 end
end