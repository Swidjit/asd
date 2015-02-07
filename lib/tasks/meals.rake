namespace :meals do
  task :process_completed  => :environment do
    @old_meals = Meal.past
    @old_meals.each do |m|
      m.rsvps.each do |r|
        r.user.decrement!(:credits, m.cost)
        m.user.increment!(:credits, m.cost)
        @xfer = Transfer.new(:recipient_id=>m.user.id,:sender_id=>r.user.id,:credits=>m.cost, :category=>"meal", :transfer_status=>"pending")
        @xfer.save

        notification = Notification.new
        notification.notifier = @xfer
        notification.sender = m.user
        notification.notifier_action = "meal"
        notification.receiver = r.user

        notification.save
      end
    end
  end
end
