class RsvpsController < ApplicationController
  respond_to :js

  def create
    @rsvp = Rsvp.where(:meal_id=>params[:meal_id], :user_id=>current_user.id)
    if @rsvp.present?
      @rsvp.first.destroy
      respond_with do |format|
        format.js {render 'destroy', :locals=>{id:params[:meal_id]}}
      end
    else
      @rsvp = Rsvp.new(:meal_id=>params[:meal_id], :user_id=>current_user.id)
      @rsvp.save
      respond_with do |format|
        format.js {render 'create', :locals=>{id:params[:meal_id]}}
      end
    end
  end

end
