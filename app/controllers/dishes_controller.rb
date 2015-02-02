class DishesController < ApplicationController
  respond_to :json, :html
  def create
    @dish = Dish.create(dish_params)
    @dish.meal_id = params[:meal_id]
    if @dish.save

    end
  end

  def destroy
    @dish = Dish.find(params[:id])
    if @dish.destroy

    else
      render :js => "alert('error deleting dish');"
    end
  end

  def update
    @dish = Dish.find params[:id]

    respond_to do |format|
      if @dish.update_attributes(dish_params)
        format.html { redirect_to(@dish, :notice => 'User was successfully updated.') }
        format.json { respond_with_bip(@dish) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@dish) }
      end
    end
  end

  def dish_params
    params.require(:dish).permit(:title, :description)
  end

end