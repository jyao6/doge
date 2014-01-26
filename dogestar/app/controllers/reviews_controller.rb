class ReviewsController < ApplicationController
	before_action :can_review, only: [:new, :create]
	def new
		@review = Review.new(:transaction_id => params[:transaction_id])
	end

	def create
		@review = Review.new(review_params)
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

		def can_review
			@service = Service.find(params[:service_id])
			@transaction = Transaction.active.past.of_user(current_user.id).find_by_id(params[:transaction_id])
			if @transaction.nil? or (@service.user_id == current_user.id)
				flash[:notice] = "You cannot write a review for this service."
				redirect_to @service
			end
		end
end
