class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|
      t.string :title, :default => :null
      t.string :description, :default => :null
    end
  end
end
