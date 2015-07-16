class ChargesController < ApplicationController
  def new
  end

  def create
    @amount = params[:total].to_d * 100

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :card  => params[:stripeToken]
    )

    if Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount.to_i,
      :description => 'Credit Card Payment',
      :currency    => 'usd'
      )

      redirect_to addresses_path
    end

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to charges_path
    end
end
