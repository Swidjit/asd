class Flag < ActiveRecord::Base
  belongs_to :user

  after_create :notify_user

  def notify_user
    notification = Notification.new
    notification.notifier = self
    notification.sender = self.user

    notification.receiver = User.find(self.flagged_user)
    notification.save!
  end
end
