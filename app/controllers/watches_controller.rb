class WatchesController < ApplicationController
  respond_to :js

  def create
    @watch = Watch.where(:meal_id=>params[:meal_id], :user_id=>current_user.id)
    if @watch.present?
      @watch.first.destroy
      respond_with do |format|
        format.js {render 'destroy', :locals=>{id:params[:meal_id]}}
      end
    else
      @watch = Watch.new(:meal_id=>params[:meal_id], :user_id=>current_user.id)
      @watch.save
      respond_with do |format|
        format.js {render 'create', :locals=>{id:params[:meal_id]}}
      end
    end
  end

end
