class UpdateUserTokens < ActiveRecord::Migration
  def change
    change_column :users, :tokens, :integer, :default => 0
  end
end
