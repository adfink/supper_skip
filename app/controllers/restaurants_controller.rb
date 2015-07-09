class RestaurantsController < ApplicationController
  before_action :load_restaurant, only: [:edit]
  before_action :auth, only: [:edit]
  before_action :require_login, only: [:edit]


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
      UserRole.create(user_id: current_user.id, restaurant_id: restaurant.id, role_id: 1)
      redirect_to restaurant
    else
      flash.now[:errors] = restaurant.errors.full_messages.join(", ")
      render :new
    end
  end

  def index
    @restaurants = Restaurant.all
  end

  def edit
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :description, :display_name)
  end

  private

  def auth
    this_dude = Permissions.new(current_user)

    unless this_dude.can_edit_restaurant?(@restaurant)
      flash[:notice] = "get lost, #{current_user.name}!"
      redirect_to root_path
    end
  end

  def require_login
    unless current_user
      redirect_to login_path
    end
  end

  def load_restaurant
    @restaurant = Restaurant.find_by(display_name: params[:id])
  end
end
