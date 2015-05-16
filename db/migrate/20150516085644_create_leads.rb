class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.belongs_to :requester
      t.belongs_to :receiver
      t.timestamps
    end
  end
end
