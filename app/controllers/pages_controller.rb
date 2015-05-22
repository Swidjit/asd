class PagesController < ApplicationController

  def home
    @dealmaker_tags = User.dealmaker_counts
    @dealmaker_match_tags = User.dealmaker_match_counts
  end

  def index
    @title = params[:page_name].titleize
    render params[:page_name]
  end
end
