class UsersController < ApplicationController

  before_action :set_user, only: [:edit, :update, :destroy, :finish_signup]
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
    @users = User.all
    if params.has_key?(:market)
      tags = params[:market].split(',')
      @users = @users.tagged_with([tags],:on => :market, :any => true)
    end
  end

  def update
    # authorize! :update, @user
    respond_to do |format|
      if @user.update(user_params)
        sign_in(@user == current_user ? @user : current_user, :bypass => true)
        format.html { redirect_to user_path(@user), notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    @dealmaker_tags = User.dealmaker_counts
    @dealmaker_match_tags = User.dealmaker_match_counts
    # authorize! :update, @user
    if request.patch? && params[:user] #&& params[:user][:email]
      if @user.update(user_params)

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

    current_user.update_attribute(:avatar, URI.parse(URI.unescape(params['url'])))
    @user = User.find(params[:id])
  end
  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit([:username, :first_name, :last_name, :email, :address, :about, :avatar, :market_list,:dealmaker_list, :expertise_list, :dealmaker_match_list,:password, :password_confirmation])
  end

end
