class AddListingIdToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :listing_id, :integer, :null=>:false
  end
end
