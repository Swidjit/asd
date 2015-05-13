class ListingsController < ApplicationController

  respond_to :html

  def new
    @listing = Listing.new
  end

  def create

    @listing = Listing.create(listing_params)
    if @listing.save!
      respond_with @listing
    end
  end

  def destroy
    @listing = Listing.find(params[:id])
    if @listing.destroy
      redirect_to root_path
    end
  end

  def show
    @listing = Listing.find(params[:id]) unless @listing.present?


  end

  def edit
    @listing = Listing.find(params[:id])
  end

  def update
    @listing = Listing.find(params[:id])
    if @listing.update_attributes(listing_params)
      respond_with(@listing)
    end
  end

  def index

    @listings = Listing.all
    if params.has_key?(:dietary)
      tags = params[:dietary].split(',')
      @listings = @listings.tagged_with([tags],:on => :dietary, :any => true)
    end
    if params.has_key?(:cuisine)
      tags = params[:cuisine].split(',')
      @listings = @listings.tagged_with([tags],:on => :cuisine, :any => true)
    end
    if params.has_key?(:location)
      tags = params[:location].split(',')
      @listings = @listings.tagged_with([tags],:on => :location, :any => true)
    end
    if params.has_key?(:env)
      tags = params[:env].split(',')
      @listings = @listings.tagged_with([tags],:on => :env, :any => true)
    end

  end

  def custom
    dietary_tags = current_user.dietary_list.split(',')
    @listings = Listing.tagged_with([dietary_tags],:on => :dietary, :any => true)
    render :index
  end

  def autocomplete_dietary_search
    @tags = Listing.dietary_counts.where("name LIKE (?)","%#{params[:q]}%")
    respond_to do |format|
      format.json { render :json => @tags.collect{|tag| {:id => tag.name, :name => tag.name}} }
    end
  end

  def show_rsvp
    #change to show rsvp for future events only
    @listing = Listing.unscoped.find(params[:id])
  end

  private

  def listing_params
    params.require(:listing).permit(:user_id, :title, :description, :pic, :address, :country, :city, :price, :noi, :arv, :property_type, :units, :status)
  end
end
