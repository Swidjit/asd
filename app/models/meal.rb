class Meal < ActiveRecord::Base

  validates_presence_of :start_time, :cost, :address, :title, :dine_in_count

  acts_as_taggable_on :dietary

  belongs_to :user
  has_many :rsvps
  has_many :watches
  acts_as_commentable


  scope :future, lambda { where('start_time > ?', Time.now) }
  scope :past, lambda { where('start_time <= ?', Time.now) }



end
