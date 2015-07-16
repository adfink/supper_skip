class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :current_restaurant
  helper_method :cart

  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    end
  end

  def cart
    @cart ||= Cart.new(session)
  end

  def current_restaurant
    if params[:restaurant_id]
      @current_restaurant ||= Restaurant.find(params[:restaurant_id])
    end
  end
end
