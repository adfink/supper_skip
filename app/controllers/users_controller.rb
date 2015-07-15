class UsersController < ApplicationController
	# layout "special_layout"
	def index
		@users = User.all
	end

	def new
		@user = User.new
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(user_params)
      redirect_to @user, notice: "profile Updated"
    else
      flash.now[:errors] = @user.errors.full_messages.join(", ")
      render :edit
    end
  end

	def create
		@user = User.new(user_params)
		if @user.save
			redirect_to login_path, notice: "You Have Successfully Created A New Account!"
		else
			render :new
		end
	end

	def show
		@user = User.find(params[:id])
	end

	private

	def user_params
		params.require(:user).permit(:full_name, :email_address, :screen_name, :password, :password_confirmation)
	end
end
