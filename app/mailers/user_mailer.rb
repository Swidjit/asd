class UserMailer < ActionMailer::Base


  default from: "do-not-reply@anysizedeals.com"
  default :to => ""

  def announce_account(user)
    @user = user
    @message = "Thanks for creating your account and joining our growing network of real estate matchmakers.  To start making matches, visit our site and browse the available deals and nearby dealmakers."
    mail(:subject => "Welcome to AnySizeDeals.com", :to => user.email)
  end
  def announce_account_transfer(user)
    @user = user
    @message = "Your account has been transfered to new ASD.  For seciurity purposes, you will need to reset your password:"
    puts @message
    mail(:subject => "Welcome to AnySizeDeals.com", :to => user.email)
  end
end
