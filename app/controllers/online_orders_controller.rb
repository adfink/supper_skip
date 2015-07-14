class OnlineOrdersController < ApplicationController
  before_action :authenticate_user
  before_action :set_online_order, only: [:show, :update]

  def index
    @online_orders = current_user.online_orders
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
      @online_order = OnlineOrder.create(user_id: session[:user_id])
      order_creator = OrderCreator.new(session[:cart_items], @online_order, params[:address])
      order_creator.create_restaurant_orders
      session[:cart_items] = {}
      redirect_to verification_path
    end
  end

  def update
    user = User.find(params[:user_id])
    order = Order.find(params[:order][:id])

    if order.update_status(params[:order])
      redirect_to user_online_order_path(user, @online_order), notice: "Order Status Updated!"
    else
      redirect_to user_online_order_path(user, @online_order), alert: "Order Status Update Failed."
    end
  end

  private
  def authenticate_user
    unless current_user
      flash[:notice] = 'Please log in or create account to complete order'
      session[:return_to] = cart_path
      redirect_to new_user_path
    end
  end

  def set_online_order
    @online_order = current_user.online_orders.find(params[:id])
  end
end
