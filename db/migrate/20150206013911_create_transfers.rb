class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.belongs_to :recipient
      t.belongs_to :sender
      t.integer :credits
      t.string :category
      t.string :transfer_status
      t.timestamps
    end
  end
end
