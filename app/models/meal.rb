class Meal < ActiveRecord::Base

  validates_presence_of :start_time, :cost, :address, :title, :dine_in_count

  acts_as_taggable_on :dietary

  belongs_to :user
  has_many :rsvps
  has_many :watches
end
