class MessagesController < ApplicationController
  def create
    @message = Message.create!(:user => current_user, :body => params[:conversation_message][:body], :conversation_id => params[:conversation_message][:conversation_id])
    c = Conversation.find(params[:conversation_message][:conversation_id])
    if c.user_id == current_user.id
      @recipient = User.find(c.recipient_id)
    else
      @recipient = User.find(c.user_id)
    end
    puts "sending"
    puts @recipient
    MessageMailer.notify_of_message(@recipient, params[:conversation_message][:body], current_user).deliver
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end
end
