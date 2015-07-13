class ItemsController < ApplicationController
  before_action :load_restaurant, only: [:new, :create]

  def index
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
  end

  def create
    item = Item.new(item_params)
    item.restaurant_id = @restaurant.id

    if item.save
      redirect_to @restaurant
    else
      flash.now[:errors] = item.errors.full_messages.join(", ")
      render :new
    end
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :price)
  end

  def load_restaurant
    @restaurant = Restaurant.find_by(display_name: params[:restaurant_id])
  end
end
