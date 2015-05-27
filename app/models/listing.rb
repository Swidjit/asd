class Listing < ActiveRecord::Base

  validates_presence_of :title, :price

  belongs_to :user
  has_many :images, :dependent => :delete_all
  scope :paid, -> { joins(:user).where("users.tokens > 0") }

  geocoded_by :address   # can also be an IP address
  after_validation :geocode
  before_save :calculate_cap_rate
  #has_attached_file :pic, :styles => { :medium => "450x450>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  #validates_attachment_content_type :pic, :content_type => /\Aimage\/.*\Z/
  scope :by_property_type, -> pt { where(:property_type => pt) }

  def calculate_cap_rate
    self.cap_rate = (self.noi.to_f/self.price).round(2)

  end
end
