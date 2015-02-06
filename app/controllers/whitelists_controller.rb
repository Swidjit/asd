class WhitelistsController < ApplicationController
  respond_to :js

  def create
    @whitelist = Whitelist.where(:whitelisted_user_id=>params[:user_id], :user_id=>current_user.id)
    if @whitelist.present?
      @whitelist.first.destroy
      respond_with do |format|
        format.js {render 'destroy'}
      end
    else
      @whitelist = Whitelist.new(:whitelisted_user_id=>params[:user_id], :user_id=>current_user.id)

      if @whitelist.save
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
