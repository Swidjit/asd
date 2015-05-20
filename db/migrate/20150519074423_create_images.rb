class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.belongs_to :listing
    end
  end
end
