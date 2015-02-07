class MealsController < ApplicationController

  respond_to :html

  def new
    @meal = Meal.new
    4.times { @meal.dishes.build }
  end

  def create

    @meal = Meal.create(meal_params)
    if @meal.save!
      respond_with @meal
    end
  end

  def destroy
    @meal = Meal.find(params[:id])
    if @meal.destroy
      redirect_to root_path
    end
  end

  def show
    @meal = Meal.find(params[:id]) unless @meal.present?
    @new_item = true if @meal.created_at > (Time.now - 2.seconds)
    @comments = @meal.comment_threads.order('created_at desc')
    @new_comment = Comment.build_from(@meal, current_user.id, "")
    @dietary_tags = Meal.dietary_counts
    @cuisine_tags = Meal.cuisine_counts
    @location_tags = Meal.location_counts
    @env_tags = Meal.env_counts

  end

  def edit
    @meal = Meal.find(params[:id])
  end

  def update
    @meal = Meal.find(params[:id])
    if @meal.update_attributes(meal_params)
      respond_with(@meal)
    end
  end

  def index
    if params.has_key?(:type)
      types = params[:type].split(',')
      if types.include?("watched")
        @meals = Meal.where("id in (?)",current_user.watches.map(&:meal_id))
      elsif types.include?("rsvped")
        @meals = Meal.where("id in (?)",current_user.rsvps.map(&:meal_id))
      end
    else
      @meals = Meal.future.all.order(start_time: :desc)
    end

    if params.has_key?(:following)
      @meals = @meals.where('user_id in (?)',current_user.subscriptions.where(:subscription_type=>"user").map(&:subscription_id))
    end

    if params.has_key?(:dietary)
      tags = params[:dietary].split(',')
      @meals = @meals.tagged_with([tags],:on => :dietary, :any => true)
    end
    if params.has_key?(:cuisine)
      tags = params[:cuisine].split(',')
      @meals = @meals.tagged_with([tags],:on => :cuisine, :any => true)
    end
    if params.has_key?(:location)
      tags = params[:location].split(',')
      @meals = @meals.tagged_with([tags],:on => :location, :any => true)
    end
    if params.has_key?(:env)
      tags = params[:env].split(',')
      @meals = @meals.tagged_with([tags],:on => :env, :any => true)
    end

    #lets only show events in the future her
    @meals = @meals.future
    #ok this is going to be messy for now
    @ids = @meals.map(&:id)
    @hidden_meals = Meal.where('user_id in (?)',Blacklist.where(:blacklisted_user_id=>current_user).map(&:user_id)).map(&:id)
    @meal_ids = @ids - @hidden_meals
    @private_meals = Meal.unscoped.future.invite_only.map(&:id)
    @meal_ids =  @private_meals | @meal_ids
    @meals = Meal.unscoped.where('id in (?)', @meal_ids).order(start_time: :desc)
  end

  def custom
    dietary_tags = current_user.dietary_list.split(',')
    @meals = Meal.tagged_with([dietary_tags],:on => :dietary, :any => true)
    render :index
  end

  def autocomplete_dietary_search
    @tags = Meal.dietary_counts.where("name LIKE (?)","%#{params[:q]}%")
    respond_to do |format|
      format.json { render :json => @tags.collect{|tag| {:id => tag.name, :name => tag.name}} }
    end
  end

  private

  def meal_params
    params.require(:meal).permit(:user_id, :title, :description, :address, :start_time, :end_time, :cost, :dine_in_count, :take_out_count, :dietary_list, :cuisine_list, :env_list, :location_list, dishes_attributes: [:title, :description])
  end
end
