class ServicesController < ApplicationController
	def new
		@service = Service.new
	end

	def create
		# @service = User.new(service_params)
		# if @service.save
		# 	flash[:success] = "Service added!"
		# 	redirect_to @service
		# else
		# 	render 'new'
		# end
	end
end
