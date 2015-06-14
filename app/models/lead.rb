class Lead < ActiveRecord::Base
  belongs_to :requester, :class_name => 'User'
  belongs_to :receiver, :class_name => 'User'

  validates_uniqueness_of :listing_id, scope: :requester_id
end