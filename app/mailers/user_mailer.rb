class UserMailer < ActionMailer::Base


  default from: "do-not-reply@anysizedeals.com"
  default :to => ""

  def announce_account(user)
    @user = user
    @message = "Thanks for creating your account and joining our growing network of real estate professionals.  To start making matches, visit our site and browse the available deals and nearby dealmakers."
    mail(:subject => "Welcome to AnySizeDeals.com", :to => user.email)
  end
  def announce_account_transfer(user)
    @user = user
    @message = "Your account has been transfered to new ASD.  For security purposes, you will need to reset your password. Until you do so, your profile will not be visible among the dealmakers on the site."
    puts @message
    mail(:subject => "Welcome to AnySizeDeals.com", :to => user.email)
  end
  def announce_to_admin(user)
    @user = user
    mail(:subject => "New User", :to => 'snson@anysizedeals.com')
  end
  def notify_of_pending_transfer(user)
    @user = user
    mail(:subject => "AnySizedeals.com Account Transfer Pending", :to => @user.email)
  end
end
