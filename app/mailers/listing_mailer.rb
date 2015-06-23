class ListingMailer < ActionMailer::Base


  default from: "do-not-reply@anysizedeals.com"
  default :to => ""

  def announce_latest(user, count)
    @user = user
    @count = count
    if count > 1
      sbj = "Check out the new listing on AnySizeDeals.com"
    else
      sbj = "New listings on AnySizeDeals.com"
    end
    mail(:subject => sbj, :to => user.email)
  end

end
