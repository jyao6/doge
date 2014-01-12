class ReviewsController < ApplicationController
	def new
		render :json => params[:service_id].to_i.to_json
	end

	def create
	end

	def destroy
	end

end
