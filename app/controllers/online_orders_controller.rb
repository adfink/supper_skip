class OnlineOrdersController < ApplicationController
  before_action :authenticate_user
  before_action :set_online_order, only: [:show]

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

      my_hash = {}
      session[:cart_items].each do |item_id, quantity|
        item = Item.find(item_id.to_i)
        if my_hash[item.restaurant_id].nil?
          my_hash[item.restaurant_id] = [[item.id, quantity]]
        else
          my_hash[item.restaurant_id] << [item.id, quantity]
        end
      end

      my_hash.each do |restaurant_id, items_and_quantity|
        order = Order.create(user_id: current_user.id,
                     online_order_id: @online_order.id,
                     restaurant_id: restaurant_id,
                     address_id: params[:address],
                     status: "paid" )
        items_and_quantity.each do |item_id, quantity|
          order.order_items.create(item_id: item_id, quantity: quantity)
        end
      end
      session[:cart_items] = {}
      redirect_to verification_path

      # @online_order = OnlineOrder.create(user_id: session[:user_id])
      # restaurant_ids = session[:cart_items].keys.map do |item_id|
      #   Item.find(item_id.to_i).restaurant_id
      # end.uniq
      #
      # @created_orders = restaurant_ids.map do |id|
      #                 Order.create(user_id: current_user.id,
      #                               online_order_id: @online_order.id,
      #                               restaurant_id: id,
      #                               address_id: params[:address],
      #                               status: "paid" )
      # end
      # @created_orders.map do |order|
      #   the_restaurant_id = order.restaurant_id
      #   items_for_order = session[:cart_items].keys.map do |item_id|
      #     Item.find(item_id.to_i)
      #   end.select do |item|
      #     item.restaurant_id == the_restaurant_id
      #   end
      #   items_for_order.map do |item|
      #     order.order_items.create(item_id: item.id, quantity: 5)
      #   end
      # end
      # session[:cart_items] = {}
      # redirect_to verification_path
      end
    end

  def edit
  end

  def update
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
