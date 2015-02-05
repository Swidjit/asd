class AddCountAndTypeToRsvps < ActiveRecord::Migration
  def change
    add_column :rsvps, :num, :integer, :default => 0, :null=>:false
    add_column :rsvps, :rsvp_type, :string, :null => :false
  end
end
