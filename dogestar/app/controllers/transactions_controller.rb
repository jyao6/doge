class TransactionsController < ApplicationController
  before_action :for_signed_in, only: [:new, :create, :history]

  def new
  	@transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.price = final_price(@transaction.service.price)
    @transaction.buyer_id = current_user.id
    @transaction.status = :ok
  	if @transaction.save
      OrderNotification.create(user_id: @transaction.service.user_id, sender_id: current_user.id)
  	  flash[:success] = "Order successful!"
  	  redirect_to current_user
  	else
  	  render 'new'
  	end
  end

  def history
  	@orders = Transaction.of_user(current_user.id)
  end

  def cancel
    @transaction = Transaction.find(params[:id])
    if current_user?(@transaction.buyer) or current_user?(@transaction.seller)
      @transaction.status = :cancelled
      @transaction.save
      send_to = current_user?(@transaction.buyer) ? @transaction.seller.id : @transaction.buyer_id
      CancelNotification.create(user_id: send_to, sender_id: current_user.id)
      flash[:success] = "Order successfully cancelled."
    end
    redirect_to current_user
  end

  def upcoming
    @bought = Transaction.active.future.where(buyer_id: current_user.id)
    @sold = Transaction.joins(:service).active.future.where(services: {user_id: current_user.id})
  end

  private

    def transaction_params
      params.require(:transaction).permit(:appt_time, :service_id)
    end

    def final_price(p)
      1.00 * p
    end
end
