class ReviewsController < ApplicationController
	def new
		@service = Service.find(params[:service_id])
		@transaction = Transaction.find(params[:transaction_id])
		@review = Review.create(:transaction_id => params[:transaction_id])
	end

	def create
		@service = Service.find(params[:service_id])
		@transaction = Transaction.find(params[:transaction_id])
		@review = Review.create(review_params)
		if @review.save
			@transaction.review = @review
			@service.update_attributes(:avg_rating => Review.joins(:transaction).where(transactions: {service_id: params[:service_id]}).average(:rating))
			flash[:success] = "Thanks for rating!"
			redirect_to root_url
	  	else
	  		render 'new'
	  	end
	end

	def destroy
	end

	private
		def review_params
			params.require(:review).permit(:rating, :review)
		end
end
