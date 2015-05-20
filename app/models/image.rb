class Image < ActiveRecord::Base

  belongs_to :listing
  has_attached_file :pic, :styles => { :medium => "450x450>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :pic, :content_type => /\Aimage\/.*\Z/

end
