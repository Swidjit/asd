class Meal < ActiveRecord::Base

  validates_presence_of :start_time, :cost, :address, :title, :dine_in_count

  acts_as_taggable_on :dietary, :cuisine, :env, :location

  belongs_to :user
  has_many :rsvps
  has_many :watches, :dependent => :delete_all
  has_many :dishes, :dependent => :delete_all
  acts_as_commentable
  accepts_nested_attributes_for :dishes

  after_save :delete_empty_dishes, :notify_users_of_meal_update
  before_destroy :notify_rsvped_users

  scope :future, lambda { where('start_time > ?', Time.now) }
  scope :past, lambda { where('start_time <= ?', Time.now) }
  scope :upcoming, lambda { where('start_time <= ? and start_time > ?', Time.now + 1.days, Time.now) }
  scope :invite_only, lambda { where('visibility = ?', "private") }
  default_scope -> { where('visibility = ?', "public") }

  def future
    return true if self.start_time > Time.now
  end
  def past
    return true if self.start_time < Time.now
  end

  def delete_empty_dishes
    dishes.each do |d|
      puts d
      d.destroy if d.title.empty?
    end
  end

  def notify_rsvped_users
    rsvps = self.rsvps
    rsvps.each do |r|
      notification = Notification.new
      notification.notifier = self
      notification.sender = self.user
      notification.notifier_action = "cancel"
      notification.receiver = r.user

      notification.save
      r.destroy
    end
  end

  def notify_users_of_meal_update
    rsvps = self.rsvps
    rsvps.each do |r|
      notification = Notification.new
      notification.notifier = self
      notification.sender = self.user
      notification.notifier_action = "update"
      notification.receiver = r.user

      notification.save
    end
  end
end
