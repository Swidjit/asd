namespace :scheduler do
  desc "This task is called by the Heroku cron add-on"
  task :call_page => :environment do
     require "net/http"
     uri = URI.parse('https://quiet-refuge-7178.herokuapp.com/')
     Net::HTTP.get(uri)
  end

  task :announce_new_deals => :environment do

    new_listings = Listing.paid.where('listings.created_at > ?', Time.now-24.hours)

    if new_listings.length > 0

      User.all.each do |u|

        ListingMailer.announce_latest(u,new_listings.length).deliver
      end
    end
  end

  task :notify_pending_users => :environment do
    users = User.where.not(:confirm_code => '-1')
    if users.length > 0

      users.each do |u|
        UserMailer.notify_of_pending_transfer(u).deliver
      end
    end
  end
end