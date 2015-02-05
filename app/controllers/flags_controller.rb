class FlagsController < ApplicationController
  respond_to :js

  def create
    @flag = Flag.create(flag_params)
    @flag.user = current_user
    @flag.save
  end

  private

  def flag_params
    params.permit(:flagged_user, :meal_id, :abused_term, :comment)
  end

end
