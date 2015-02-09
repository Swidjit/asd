class RsvpsController < ApplicationController
  respond_to :js

  def create
    @meal = Meal.find(params[:meal_id])

    #will have to change this eventually to make sure current_count + new_count < max_rsvp_count
    if params[:rsvp][:dine_in_count].to_i > 0 && @meal.rsvps.dine_in.sum(:num) < @meal.dine_in_count
      @rsvp = Rsvp.new(:meal_id=>params[:rsvp][:meal_id], :user_id=>current_user.id, :rsvp_type => "dine_in", :num => params[:rsvp][:dine_in_count])
      @rsvp.save
    end
    if params[:rsvp][:take_out_count].to_i > 0 && @meal.rsvps.take_out.sum(:num) < @meal.take_out_count
      @rsvp = Rsvp.new(:meal_id=>params[:rsvp][:meal_id], :user_id=>current_user.id, :rsvp_type => "take_out", :num => params[:rsvp][:take_out_count])
      @rsvp.save
    end

    respond_with do |format|
      if params[:rsvp][:origin] == "feed"
        format.js {render 'create_from_feed', :locals=>{id:params[:meal_id]}}
      else
        format.js {render 'create', :locals=>{id:params[:meal_id]}}
      end
    end
  end

  def destroy
    @meal = Meal.find(params[:meal_id])
    @rsvps = Rsvp.where(:meal_id => params[:meal_id], :user_id => current_user.id).destroy_all
    if params[:origin] == "feed"
      respond_with do |format|
        format.js {render 'destroy', :locals=> {id:params[:meal_id]}}
      end
    else
      respond_with do |format|
        format.js {render 'destroy_from_feed', :locals=>{id:params[:meal_id]}}
      end
    end
  end

end
