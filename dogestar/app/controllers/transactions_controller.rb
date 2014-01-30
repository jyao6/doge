class TransactionsController < ApplicationController
  before_action :for_signed_in, only: [:new, :create, :history]

  def new
    @transaction = Transaction.new
    @transaction.service = Service.find(params[:service_id])
  end

  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.location = order_location(@transaction.service)
    @transaction.appt_time = appt_time_zoned
    @transaction.price = final_price(@transaction.service.price)
    @transaction.buyer_id = current_user.id
    @transaction.status = :ok
  	if @transaction.save
  	  flash[:success] = "Order successful!"
  	  redirect_to current_user
  	else
  	  render 'new'
  	end
  end

  def history
  	@orders = Transaction.of_user(current_user.id).order(created_at: :desc).page(params[:page])
  end

  def cancel
    @transaction = Transaction.find(params[:id])
    if current_user?(@transaction.buyer) or current_user?(@transaction.seller)
      if current_user?(@transaction.buyer)
        @transaction.status = :buyer_cancel
      else
        @transaction.status = :seller_cancel
      end
      @transaction.save
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
      params.require(:transaction).permit(:service_id)
    end

    def appt_time_zoned
      current_timezone.parse(params[:transaction][:appt_time])
    end

    def final_price(p)
      1.00 * p
    end

    def order_location(service)
      if !service.can_travel or params[:transaction][:location].empty?
        service.location
      else
        params[:transaction][:location]
      end
    end

end
