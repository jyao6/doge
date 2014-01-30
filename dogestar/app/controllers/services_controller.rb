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
		if !Rails.cache.exist?("services") or params[:type].nil?
			Rails.cache.write("services", Service.approved)
		end
		@services = sorter.page(params[:page])
	end

	def filter
		cat_query = ""
		Service.categories.each do |c|
			if !params[c].nil?
				cat_query += " OR category = " + Service.category_num(c).to_s + ""
			end
		end
		if !params[:lesson].nil?
			lesson_query = "lesson = true"
		end
		if !params[:can_travel].nil?
			travel_query = "can_travel = true"
		end
		if params[:min_price] != ""
			price_query = "price > " + params[:min_price]
		else
			price_query = ""
		end
		if params[:max_price] != ""
			if price_query != ""
				price_query += " AND "
			end
			price_query += "price < " + params[:max_price] 
		end
		unsorted_services = Service.where(cat_query[4..-1]).where(lesson_query).where(travel_query).where(price_query)

		Rails.cache.write("services", unsorted_services)
		@services = sorter.page(params[:page])
		render "index"
	end

	def search
		# render :json => params[:q].split(" ").to_json
		# params[:q].split(" ").each do |word|
		# 	Service.where()
		# end
		keyword = "%" + params[:q].to_s + "%"
		search_results = Service.where("name LIKE ?", keyword) + Service.where("description LIKE ?", keyword)
		sortable_results = Service.where("name LIKE ? OR description LIKE ?", keyword, keyword)
		Rails.cache.write("services", sortable_results)
		@services = Kaminari.paginate_array(search_results).page(params[:page])
		render "index"
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

		def sorter
			list = Rails.cache.read("services")
			if !params[:orient_desc].nil? and params[:orient_desc].to_i == 0
				orientation = :asc
				@desc = 1
			else
				orientation = :desc
				@desc = 0
			end

			if params[:type] == "rating"
				services = list.order(avg_rating: orientation)
			elsif params[:type] == "price"
				services = list.order(price: orientation)
			else
				services = list.order(created_at: orientation)
			end

			return services
		end
end
