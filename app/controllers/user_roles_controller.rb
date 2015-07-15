class UserRolesController < ApplicationController

  before_action :load_restaurant

  def new
    @user_role = UserRole.new
    # @roles = Role.all
  end

  def index
    # binding.pry
    @staff_roles = UserRole.where(restaurant_id:@restaurant.id)
  end

  def create

    email = params[:user_role][:user_id]
    possible_staff = User.find_by(email_address: email )

    if possible_staff
      # binding.pry
      # restaurant = Restaurant.find_by(display_name:params[:restaurant_id])
      UserRole.create(restaurant_id: @restaurant.id, user_id: possible_staff.id, role_id:params[:user_role][:role_id])
      redirect_to restaurant_user_roles_path(@restaurant)
      flash[:notice] = "you just hired a new staff person"
      # render :new
      # flash[:notice] = "that didn't work"
    else
      # binding.pry
     new_staff = User.create(full_name:"place_holder_name", email_address:email, password: "password")
     @user_role = UserRole.create(restaurant_id: @restaurant.id, user_id: new_staff.id, role_id:params[:user_role][:role_id])
     NotificationMailer.staff_registration_email(email, @user_role, @restaurant).deliver
      redirect_to restaurant_user_roles_path(@restaurant)
    end

    # grab on to the email address and the role selected
    # use the email address to search user database to see if there exists a user with that adress
    # if there is a user, create a user_role that assigns the role to the selected user
    #if there is no user with this email address, then we create a new user, give it a random password, assign the role to this new user, and send email
  end

  private

  def load_restaurant
    @restaurant = Restaurant.find_by(display_name: params[:restaurant_id])
  end

  def user_role_params
    params.require(:user_role).permit(:user_id, :role_id, :restaurant_id)
  end




end
