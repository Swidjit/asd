class UsersController < ApplicationController

  before_action :set_user, only: [:edit, :update, :destroy]
  before_filter :ensure_signup_complete, only: [:new, :create, :update, :destroy]
  respond_to :js
  def show
    @user = User.where(:username=>params[:display_name]).first

    if user_signed_in?
      #probably a better way to do this
      @meals1 = @user.rsvps.map(&:meal_id)
      @meals2 = current_user.rsvps.map(&:meal_id)
      #make this Meal.past to only show meals that have happened
      @common_meals = Meal.where('id in (?)',(@meals1&@meals2))
    end
  end

  def edit

  end

  def update
    # authorize! :update, @user
    respond_to do |format|
      if @user.update(user_params)
        sign_in(@user == current_user ? @user : current_user, :bypass => true)
        format.html { redirect_to profile_path(@user.username), notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    # authorize! :update, @user
    if request.patch? && params[:user] #&& params[:user][:email]
      if @user.update(user_params)

        sign_in(@user, :bypass => true)
        redirect_to root_path, notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
      end
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

  def transfer_credits
    @user = User.find(params[:user_id])
    if current_user.credits >= params[:credits].to_i
      current_user.decrement!(:credits, params[:credits].to_i)
      @user.increment!(:credits,params[:credits].to_i)
      @xfer = Transfer.new(:recipient_id=>@user.id,:sender_id=>current_user.id,:credits=>params[:credits].to_i, :category=>"transfer", :transfer_status=>"complete")
      @xfer.save
      respond_to do |format|
        format.js
      end
    end

  end

  def autocomplete
    @users = User.where("username LIKE (?) or first_name LIKE (?) or last_name LIKE (?)","%#{params[:q]}%","%#{params[:q]}%","%#{params[:q]}%")
    render file: 'users/search.json.rabl'
  end

  def notifications
    @notifications = current_user.notifications.includes(:sender,:notifier).reverse_order
    @notifications.each do |n|
      n.read = true
      n.save!
    end
  end

  def credit_page
    @user = User.find(params[:id])
    @xfers = @user.transfers

  end

  def manage_lists_page
    @user = User.find(params[:id])
    puts @user.whitelists
    puts "sdfsdfsdf"

  end
  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit([:name, :first_name, :last_name, :email, :address, :about, :dietary_list,:password, :password_confirmation])
  end

end
