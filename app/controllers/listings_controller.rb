class ListingsController < ApplicationController

  respond_to :html
  has_scope :by_degree

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

    @listings = apply_scopes(Listing).all

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

  def filter
    @listings = Listing.all
    if params.has_key?(:property_type) && params[:property_type].length > 0
      @listings = @listings.where(:property_type => params[:property_type])
    end
    if params.has_key?(:status)  && params[:status].length > 0
      @listings = @listings.where(:status => params[:status].downcase)
    end
    if params.has_key?(:status)  && params[:status].length > 0
      @listings = @listings.where(:status => params[:status].downcase)
    end
  end

  def generate_lead
    @listing = Listing.find(params[:id])
    @lead = Lead.new
    @lead.requester = current_user
    @lead.receiver = @listing.user
    @lead.save
    current_user.decrement!(:tokens)
    @listing.user.decrement!(:tokens)
    puts current_user
    puts @listing.user
  end

  private

  def listing_params
    params.require(:listing).permit(:user_id, :title, :description, :pic, :address, :latlng, :price, :noi, :arv, :property_type, :cap_rate, :units, :status)
  end
end
