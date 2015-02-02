class Rsvp < ActiveRecord::Base

  belongs_to :user
  belongs_to :meal, :counter_cache => true

end
