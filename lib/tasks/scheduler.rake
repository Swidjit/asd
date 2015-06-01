namespace :scheduler do
  desc "This task is called by the Heroku cron add-on"
  task :call_page => :environment do
     require "net/http"
     uri = URI.parse('https://quiet-refuge-7178.herokuapp.com/')
     Net::HTTP.get(uri)
  end
end