class Listing < ActiveRecord::Base

  validates_presence_of :title, :price

  belongs_to :user
  has_many :images, :dependent => :delete_all


  #has_attached_file :pic, :styles => { :medium => "450x450>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  #validates_attachment_content_type :pic, :content_type => /\Aimage\/.*\Z/
  scope :by_property_type, -> pt { where(:property_type => pt) }

end
