class PagesController < ApplicationController

  def home
    @dealmaker_tags = User.dealmaker_counts
    @dealmaker_match_tags = User.dealmaker_match_counts
    if user_signed_in?
      redirect_to users_path
    end
  end

  def index
    @title = params[:page_name].titleize
    render params[:page_name]
  end

  def landing
    @dealmaker_tags = User.dealmaker_counts
    @dealmaker_match_tags = User.dealmaker_match_counts
    render 'home'
  end
end
