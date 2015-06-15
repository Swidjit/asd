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
      redirect_to listings_path
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

    @listings = Listing.paid.order(created_at: :desc)
  end

  def upload_file
    @listing = Listing.unscoped.find(params[:id])
    @listing.images << Image.create(:pic => URI.parse(URI.unescape(params['url'])))
  end

  def filter
    @listings = Listing.paid.order(created_at: :desc)
    if params.has_key?(:property_type) && params[:property_type].length > 0
      @listings = @listings.where(:property_type => params[:property_type])
    end
    if params.has_key?(:status)  && params[:status].length > 0
      @listings = @listings.where(:status => params[:status].downcase)
    end
    if params.has_key?(:deal_size)  && params[:deal_size].length > 0
      case params[:deal_size].to_i
        when 1
          @listings = @listings.where('price > 0 and price < 100000')
        when 2
          @listings = @listings.where('price > 100000 and price < 500000')
        when 3
          @listings = @listings.where('price > 500000 and price < 1000000')
        when 4
          @listings = @listings.where('price > 1000000 and price < 3000000')
        when 5
          @listings = @listings.where('price > 3000000 and price < 10000000')
        when 6
          @listings = @listings.where('price > 10000000')
      end
    end
    if params.has_key?(:location) && params[:location].length > 0
      @listings = Listing.near(params[:location],25)
    end
  end

  def generate_lead
    @listing = Listing.find(params[:id])
    if @listing.user.tokens > 0
      @lead = Lead.new
      @lead.requester = current_user
      @lead.receiver = @listing.user
      @lead.listing_id = @listing.id
      if @lead.save
        current_user.decrement!(:tokens)
        @listing.user.decrement!(:tokens)
      else
        render 'lead_failed.js'
      end
    else
      redirect_to listings_path
    end
  end

  private

  def listing_params
    params.require(:listing).permit(:user_id, :title, :description, :pic, :address, :latitude,:longitude, :city, :square_footage, :price, :noi, :arv, :property_type,:units, :status)
  end
end
