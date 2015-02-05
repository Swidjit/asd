class Rsvp < ActiveRecord::Base

  belongs_to :user
  belongs_to :meal, :counter_cache => true

  scope :dine_in, -> {where(:rsvp_type=>"dine_in")}
  scope :take_out, -> {where(:rsvp_type=>"take_out")}

end
