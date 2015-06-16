class AddDefaultConfirmCode < ActiveRecord::Migration
  def change
    change_column :users, :confirm_code, :string, :default => '-1'
  end
end
