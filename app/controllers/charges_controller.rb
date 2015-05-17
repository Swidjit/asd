class ChargesController < ApplicationController

  def new
  end

  def create

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :card  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => params[:stripeCharge],
      :description => 'lead purchase',
      :currency    => 'usd'
    )

    current_user.increment!(:tokens, params[:tokenCount].to_i)

    redirect_to :back
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to charges_path
  end


end
