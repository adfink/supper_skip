class AddressesController < ApplicationController

  def index
    @address = Address.new
    @addresses = Address.where(user_id: session[:id])
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)
    @address.user_id = session[:id]
    if @address.save
      redirect_to addresses_path
    else
      render :new
    end
  end

  def destroy
    address = Address.find(params[:id])
    address.destroy
    redirect_to addresses_path
  end

  private
  def address_params
    params.require(:address).permit(:street_address, :city, :state, :zip)
  end
end
