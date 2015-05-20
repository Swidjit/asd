class AddPaperclipToImages < ActiveRecord::Migration
  def self.up
    add_attachment :images, :pic
  end

  def self.down
    remove_attachment :images, :pic
  end
end
