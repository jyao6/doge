class PhotosController < ApplicationController
  before_action :for_signed_in, only: [:new, :create]
  before_action only: [:new, :create] do
    for_service_owner(params[:service_id])
  end

  def new
    @photo  = Photo.new
  end

  def create
    @photo = Photo.new(photo_params)
    @photo.service_id = params[:service_id]
    if !@photo.save
      render 'new'
    end
  end

  def index
    if Service.exists?(id: params[:service_id])
      @service = Service.find(params[:service_id])
      @can_edit = (@service.user_id == current_user.id)
    else
      flash[:notice] =  "This service does not exist. :("
	  redirect_to root_path
    end
  end

  private

    def photo_params
    	params.require(:photo).permit(:img)
    end

end
