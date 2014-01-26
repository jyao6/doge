class ServicesController < ApplicationController
	before_action :for_signed_in, only: [:new, :create]
	before_action only: [:edit, :update, :destroy] do 
	  for_service_owner(params[:id])
	end

	def new
		@service = current_user.services.new
	end

	def create
		@service = current_user.services.new(service_params)
		if @service.save
			flash[:success] = "Service added!"
			redirect_to @service
		else
			render 'new'
		end
	end

	def show
		if Service.approved.exists?(id: params[:id])
			@service = Service.find(params[:id])
			@user = User.find(@service.user_id)
		else
			flash[:notice] =  "This service does not exist. :("
			redirect_to action: "index"
		end
	end

	def edit
	end

	def update
	    if @service.update_attributes(service_params)
	      flash[:success] = "Service updated."
	      redirect_to @service
	    else
	      render 'edit'
	    end
	end

	def index
		@services = Service.approved.order(created_at: :desc)
	end

	def show_reviews
		@rel_reviews = Review.joins(:transaction).where(transactions: {service_id: params[:id]})
	end

	private
		def service_params
			# TODO: remove legitimized in the future
			param_dict = params.require(:service).permit(:name, :price, :category, :description, :can_travel, :location, :lesson)
			param_dict[:legitimized] = true
			return param_dict
		end

end
