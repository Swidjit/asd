class MealsController < ApplicationController

  respond_to :html

  def new
    @meal = Meal.new
  end

  def create

    @meal = Meal.create(meal_params)
    if @meal.save!
      respond_with @meal
    end
  end

  def show
    @meal = Meal.find(params[:id])

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
      @meals = Meal.all.order(start_time: :desc)
    end

    if params.has_key?(:dietary)
      tags = params[:dietary].split(',')
      @meals = @meals.tagged_with([tags],:on => :dietary, :any => true)
    end
  end

  def autocomplete_dietary_search
    @tags = ActsAsTaggableOn::Tag.most_used
    puts @tags
    respond_to do |format|
      format.json { render :json => @tags.collect{|tag| {:id => tag.name, :name => tag.name}} }
    end
  end

  private

  def meal_params
    params.require(:meal).permit(:user_id, :title, :description, :address, :start_time, :end_time, :cost, :dine_in_count, :take_out_count, :dietary_list)
  end
end
