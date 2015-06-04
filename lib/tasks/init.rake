namespace :init do
  task :seed_dealmaker_tags  => :environment do
    @user = User.first
    @user.dealmaker_list.add("Cashbuyer, Wholesaler, Rehabber/Flipper, JV Partner, Buy and Hold Investor, Contractor, Title Agent, Attorney, Broker, Hard Money Lender, Owner/Developer, Capital Provider, Motivated Seller, Intermediary, Service Provider, Contractor, Architect, Lender, Investor, Property Manager, Asset Manager", parse: true)
    @user.dealmaker_match_list.add("Cashbuyer, Wholesaler, Rehabber/Flipper, JV Partner, Buy and Hold Investor, Contractor, Title Agent, Attorney, Broker, Hard Money Lender, Owner/Developer, Capital Provider, Motivated Seller, Intermediary, Service Provider, Contractor, Architect, Lender, Investor, Property Manager, Asset Manager", parse: true)

    @user.save
  end
  task :seed_expertise_tags  => :environment do
    @user = User.first
    @user.expertise_list.add("Cashbuyer, Wholesaler, Rehabber/Flipper, JV Partner, Buy and Hold Investor, Contractor, Title Agent, Attorney, Broker, Hard Money Lender, Owner/Developer, Capital Provider, Motivated Seller, Intermediary, Service Provider, Contractor, Architect, Lender, Investor, Property Manager, Asset Manager", parse: true)

    @user.save
  end
  task :reset_tokens => :environment do
    User.update_all('tokens = 0')
  end

  task :import_users => :environment do
    CSV.foreach("typing.csv") do |row|
      puts row
      puts row.user_nicename
    end
  end


  desc "import data from CSV to database"
  task :import => :environment do
    file = File.open("users-2015-06-04.csv")
    file.each do |line|
      attrs = line.split(":")

      vars = attrs[0].split(',')

      u = User.new
      u.email = vars[3]
      puts u
    end
  end


  task :reset_leads => :environment do
    Lead.delete_all
  end

end
