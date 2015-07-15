class OrdersController < ApplicationController
  before_action :load_restaurant
  before_action :authenticate_user
  before_action :set_order, only: [:show]

  def index
    @orders = @restaurant.orders
  end

  def show
  end

  def new
    @addresses = Address.where(user_id: session[:id])
    if cart.empty?
      redirect_to cart_path, notice: 'Please add items to your cart before checking out. Thank you!'
    else
      @subtotal = Cart.subtotal(session)
      @tax = Cart.tax(session)
      @total = Cart.total(session)
    end
  end

  def create
    if session[:cart_items].empty?
      redirect_to verification_path
    else
      @order = Order.create(user_id: session[:user_id], status: "ordered")
      session[:cart_items].map do |item_id, quantity|
        @order.order_items.new(item_id: item_id, quantity: quantity)
      end
      @order.address_id = params[:address]
      @order.save
      session[:cart_items] = {}
      redirect_to verification_path
    end
  end

  def edit
  end

  def update
    @order = Order.find(params[:id])

    if @order.update_status(order_params)
      redirect_to restaurant_orders_path(@restaurant), notice: "Order status updated."
    else
      redirect_to restaurant_orders_path(@restaurant), alert: "Order status update failed."
    end
  end

  private

  def order_params
    params.require(:order).permit(:status)
  end

  def authenticate_user
    user = Permissions.new(current_user)
    unless user.can_edit_restaurant?(@restaurant)
      flash[:notice] = "get lost, #{current_user.full_name}!"
      redirect_to root_path
    end
  end

  def load_restaurant
    @restaurant = Restaurant.find_by(display_name: params[:restaurant_id])
  end

  def set_order
    if @restaurant.orders.collect { |order| order.id }.include?(params[:id].to_i)
      @order = @restaurant.orders.find(params[:id])
    else
      redirect_to :root
    end
  end
end
