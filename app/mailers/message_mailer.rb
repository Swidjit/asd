class MessageMailer < ActionMailer::Base


  default from: "do-not-reply@anysizedeals.com"
  default :to => ""

  def notify_of_message(user, message, sender)
    @user = user
    @sender = sender
    @message = message
    mail(:subject => "You've received a private message on AnySizeDeals.com", :to => user.email)
  end
end
