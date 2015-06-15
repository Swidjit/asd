class UsersController < ApplicationController

  before_action :set_user, only: [:edit, :update, :destroy, :finish_signup, :listings]
  before_filter :ensure_signup_complete, only: [:new, :create, :update, :destroy]
  respond_to :js
  def show
    @user = User.where(:id=>params[:id]).first
    @market_tags = User.market_counts
    @expertise_tags = User.expertise_counts
    @dealmaker_tags = User.dealmaker_counts
    @dealmaker_match_tags = User.dealmaker_match_counts
  end

  def edit
    @market_tags = User.market_counts
    @expertise_tags = User.expertise_counts
    @dealmaker_tags = User.dealmaker_counts
    @dealmaker_match_tags = User.dealmaker_match_counts
  end

  def index
    if user_signed_in?
      @users = User.where(:confirm_code => nil).with_distance_to(current_user.address).order("distance")
    else
      @users = User.where(:confirm_code => nil).all
    end

    @dealmaker_tags = User.dealmaker_counts
    if params.has_key?(:home_form)
      @users = @users.tagged_with(params[:dealmaker_match],:on => :dealmaker, :any => true)
      @users = @users.tagged_with(params[:dealmaker],:on => :dealmaker_match, :any => true)
    end
    if params.has_key?(:market)
      tags = params[:market].split(',')
      @users = @users.tagged_with([tags],:on => :market, :any => true)
    end
    if params.has_key?(:expertise)  && params[:expertise].length > 0
      @users = @users.tagged_with(params[:expertise],:on => :expertise)
    end

  end

  def update
    # authorize! :update, @user
    respond_to do |format|
      if @user.update(user_params)
        case params[:user][:deal_size]
          when '$0-$100K'
            @user.max_deal = 100000
            @user.min_deal = 0
          when '$100K-$500K'
            @user.max_deal = 500000
            @user.min_deal = 100000
          when '$500K-$1MM'
            @user.max_deal = 1000000
            @user.min_deal = 500000
          when "$1MM-$3MM"
            puts 'blah'
            @user.max_deal = 3000000
            @user.min_deal = 1000000
          when "$3MM-$10MM"
            @user.max_deal = 10000000
            @user.min_deal = 3000000
          when "$10MM +"
            @user.max_deal = 999999999
            @user.min_deal = 10000000
        end
        @user.save

        sign_in(@user == current_user ? @user : current_user, :bypass => true)
        format.html { redirect_to user_path(@user), notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def confirm

    @user = User.where(:email=>params[:email], :confirm_code=>params[:confirm_code]).first
    if @user.nil?
      redirect_to :back
    else
      @user.confirm_code = nil
      @user.save
      sign_in @user, :bypass => true
      redirect_to edit_password_user_path(@user)
    end


  end

  def edit_password
    @user = current_user
  end

  def update_password
    @user = User.find(current_user.id)
    if @user.update(user_password_params)
      # Sign in the user by passing validation in case their password changed
      sign_in @user, :bypass => true
      redirect_to root_path
    else
      render "edit"
    end
  end

  def filter
    if user_signed_in?
      @users = User.with_distance_to(current_user.address).order("distance")
    else
      @users = User.all
    end
    @users = @users.where(:confirm_code => nil)
    if params.has_key?(:location)  && params[:location].length > 0
      @users = User.near(params[:location],10)
    end
    if params.has_key?(:property_type)  && params[:property_type].length > 0
      @users = @users.where(:property_type => params[:property_type])
    end
    if params.has_key?(:purpose)  && params[:purpose].length > 0
      @users = @users.where(:purpose => params[:purpose])
    end
    if params.has_key?(:deal_size)  && params[:deal_size].length > 0

      case params[:deal_size].to_i
        when 1
          @users = @users.where('min_deal = 0')
        when 2
          @users = @users.where('min_deal = 100000')
        when 3
          @users = @users.where('min_deal = 500000')
        when 4
          @users = @users.where('min_deal = 1000000')
        when 5
          @users = @users.where('min_deal = 3000000')
        when 6
          @users = @users.where('min_deal = 10000000')
      end
      puts @users
    end
    if params.has_key?(:expertise)  && params[:expertise].length > 0
      @users = @users.tagged_with(params[:expertise],:on => :expertise)
    end
    if @users.size < 1
      render 'empty_filter'
    end

  end

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    @dealmaker_tags = User.dealmaker_counts
    @dealmaker_match_tags = User.dealmaker_match_counts
    # authorize! :update, @user
    if request.patch? && params[:user] #&& params[:user][:email]
      if @user.update(user_params)
        case params[:user][:deal_size]
          when '$0-$100K'
            @user.max_deal = 100000
            @user.min_deal = 0
          when '$100K-$500K'
            @user.max_deal = 500000
            @user.min_deal = 100000
          when '$500K-$1MM'
            @user.max_deal = 1000000
            @user.min_deal = 500000
          when "$1MM-$3MM"
            puts 'blah'
            @user.max_deal = 3000000
            @user.min_deal = 1000000
          when "$3MM-$10MM"
            @user.max_deal = 10000000
            @user.min_deal = 3000000
          when "$10MM +"
            @user.max_deal = 999999999
            @user.min_deal = 10000000
        end
        @user.save
        sign_in(@user, :bypass => true)
        redirect_to root_path, notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
      end

    else
      render :layout => "full"
    end
  end

  # DELETE /users/:id.:format
  def destroy
    # authorize! :delete, @user
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  def autocomplete
    @users = User.where("username LIKE (?) or first_name LIKE (?) or last_name LIKE (?)","%#{params[:q]}%","%#{params[:q]}%","%#{params[:q]}%")
    render file: 'users/search.json.rabl'
  end

  def autocomplete_market_search
    @tags = User.market_counts.where("name LIKE (?)","%#{params[:q].downcase}%")
    respond_to do |format|
      format.json { render :json => @tags.collect{|tag| {:id => tag.name, :name => tag.name}} }
    end
  end
  def autocomplete_dealmaker_search
    @tags = User.dealmaker_counts.where("lower(name) LIKE (?)","%#{params[:q].downcase}%")
    respond_to do |format|
      format.json { render :json => @tags.collect{|tag| {:id => tag.name, :name => tag.name}} }
    end
  end
  def autocomplete_dealmaker_match_search
    @tags = User.dealmaker_match_counts.where("lower(name) LIKE (?)","%#{params[:q].downcase}%")
    respond_to do |format|
      format.json { render :json => @tags.collect{|tag| {:id => tag.name, :name => tag.name}} }
    end
  end
  def autocomplete_expertise_search
    @tags = User.expertise_counts.where("lower(name) LIKE (?)","%#{params[:q].downcase}%")
    respond_to do |format|
      format.json { render :json => @tags.collect{|tag| {:id => tag.name, :name => tag.name}} }
    end
  end

  def upload_file

    current_user.update_attribute(:pic, URI.parse(URI.unescape(params['url'])))
    @user = User.find(params[:id])
  end

  def buy_tokens
    current_user.increment!(:tokens,params[:token_count].to_i)
    if params.has_key?(:listing_id)
      @listing = Listing.find(params[:listing_id])
    end
  end

  def listings
    @listings = @user.listings
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
  def user_password_params
    # NOTE: Using `strong_parameters` gem
    params.require(:user).permit(:password, :password_confirmation)
  end
  def user_params
    params.require(:user).permit([:username, :first_name, :last_name, :email, :max_deal, :min_deal, :deal_size,:address,:purpose, :latitude,:longitude, :property_type, :about, :avatar, :market_list,:dealmaker_list, :expertise_list, :dealmaker_match_list,:password, :password_confirmation])
  end

end
