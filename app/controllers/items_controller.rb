class ItemsController < ApplicationController
  before_action :load_restaurant
  before_action :set_item, only: [:show, :edit, :update]
  before_action :auth, only: [:new, :create, :edit, :update]

  def index
  end

  def show
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    @item.restaurant_id = @restaurant.id

    if @item.save
      flash[:success] = 'Item was successfully created.'
      redirect_to restaurant_item_path(@restaurant, @item)
    else
      flash.now[:errors] = @item.errors.full_messages.join(", ")
      render :new
    end
  end

  def edit
  end

  def update
    if @item.update_item_plus_categories(item_params)
      redirect_to restaurant_item_path(@restaurant, @item), notice: "Item Updated"
    else
      flash.now[:errors] = @item.errors.full_messages.join(", ")

      render :edit
    end
  end

  def destroy
    item = Item.find(params[:id])
    Item.destroy_all(id: item.id)
    flash[:alert] = "Item Deleted!"
    redirect_to @restaurant
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :price, :image, :category_ids => [])
  end

  def load_restaurant
    @restaurant = Restaurant.find_by(display_name: params[:restaurant_id])
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def auth
    user = Permissions.new(current_user)

    unless user.can_edit_restaurant?(@restaurant)
      flash[:notice] = "Get lost, #{current_user.name}!"
      redirect_to root_path
    end
  end
end
