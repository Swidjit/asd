class Meal < ActiveRecord::Base

  validates_presence_of :start_time, :cost, :address, :title, :dine_in_count

  acts_as_taggable_on :dietary, :cuisine, :env, :location

  belongs_to :user
  has_many :rsvps
  has_many :watches
  has_many :dishes
  acts_as_commentable
  accepts_nested_attributes_for :dishes


  scope :future, lambda { where('start_time > ?', Time.now) }
  scope :past, lambda { where('start_time <= ?', Time.now) }



end
