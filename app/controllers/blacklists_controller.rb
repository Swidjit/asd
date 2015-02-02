class BlacklistsController < ApplicationController
  respond_to :js

  def create
    @blacklist = Blacklist.where(:blacklisted_user_id=>params[:user_id], :user_id=>current_user.id)
    if @blacklist.present?
      @blacklist.first.destroy
      respond_with do |format|
        format.js {render 'destroy'}
      end
    else
      @blacklist = Blacklist.new(:blacklisted_user_id=>params[:user_id], :user_id=>current_user.id)

      if @blacklist.save
        respond_with do |format|
          format.js {render 'create'}
        end

      else
        respond_with do |format|
          format.js {render 'failed', :locals=>{id:params[:meal_id]}}
        end
      end
    end
  end

end
