class ItemsController < ApplicationController
  before_action :load_restaurant

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

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])

    if @item.update(item_params)
      redirect_to restaurant_item_path(@restaurant, @item), notice: "Item Updated"
    else
      flash.now[:errors] = @item.errors.full_messages.join(", ")
      render :edit
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
