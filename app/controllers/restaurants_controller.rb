class RestaurantsController < ApplicationController

  layout 'special_layout'
  def new
    @restaurant = Restaurant.new
  end

  def show
    @restaurant = Restaurant.find_by(display_name: params[:id])
  end

  def create
    restaurant = Restaurant.new(restaurant_params)
    restaurant.sanitize_display_name
    restaurant.user_id = session[:user_id]

    if restaurant.save
      redirect_to restaurant
    else
      flash.now[:errors] = restaurant.errors.full_messages.join(", ")
      render :new
    end
  end

  def index
    @restaurants = Restaurant.all
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :description, :display_name)
  end
end
