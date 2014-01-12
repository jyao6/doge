class TransactionsController < ApplicationController
  before_action :for_signed_in, only: [:new, :create, :history]

  def new
  	@transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.price = final_price(Service.find(@transaction.service_id).price)
    @transaction.buyer_id = current_user.id
  	if @transaction.save
  	  flash[:success] = "Order successful!"
  	  redirect_to current_user
  	else
  	  render 'new'
  	end
  end

  def history
  	@orders = Transaction.of_user(current_user.id)
  end

  private

    def transaction_params
      params.require(:transaction).permit(:appt_time, :service_id)
    end

    def final_price(p)
      1.00 * p
    end
end
