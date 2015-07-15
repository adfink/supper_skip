class CategoriesController < ApplicationController
  layout "special_layout"
  before_action :load_restaurant
  before_action :auth, only: [:new, :create, :edit, :update]

  def show
    @category = @restaurant.categories.find(params[:id])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    @category.restaurant_id = @restaurant.id

    if @category.save
      flash[:success] = 'Category was successfully created.'
      redirect_to @restaurant
    else
      flash.now[:errors] = @category.errors.full_messages.join(", ")
      render :new
    end
  end

  def edit
    @category = @restaurant.categories.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])

    if @category.update(category_params)
      redirect_to restaurant_category_path(@restaurant, @category), notice: "Category Updated"
    else
      flash.now[:errors] = @category.errors.full_messages.join(", ")
      render :edit
    end
  end

  def destroy
    category = Category.find(params[:id])
    Category.destroy_all(id: category.id)
    flash[:alert] = "Category Deleted!"
    redirect_to @restaurant
  end

  private
  def category_params
    params.require(:category).permit(:name, :description)
  end

  def auth
    user = Permissions.new(current_user)

    unless user.can_edit_restaurant?(@restaurant)
      flash[:notice] = "Get lost, #{current_user.full_name}!"
      redirect_to root_path
    end
  end

  def load_restaurant
    @restaurant = Restaurant.find_by(display_name: params[:restaurant_id])
  end
end
