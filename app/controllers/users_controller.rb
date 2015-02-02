class UsersController < ApplicationController

  before_action :set_user, only: [:edit, :update, :destroy]
  before_filter :ensure_signup_complete, only: [:new, :create, :update, :destroy]

  def show
    @user = User.where(:username=>params[:display_name]).first
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

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    accessible = [ :name, :email, :dietary_list ] # extend with your own params
    accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
    params.require(:user).permit(accessible)
  end

end
