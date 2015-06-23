namespace :scheduler do
  desc "This task is called by the Heroku cron add-on"
  task :call_page => :environment do
     require "net/http"
     uri = URI.parse('https://quiet-refuge-7178.herokuapp.com/')
     Net::HTTP.get(uri)
  end

  task :announce_new_deals => :environment do
    new_listings = Listing.where('created_at > ?',Time.now - 24.hours)
    if new_listings.length > 0

      User.all.each do |u|

        ListingMailer.announce_latest(u,new_listings.length).deliver
      end
    end
  end
end