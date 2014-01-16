class PhotosController < ApplicationController
  before_action only: [:new, :create, :choose_cover, :make_cover, :remove, :destroy] do
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


  def choose_cover
  end

  def make_cover
  	if Photo.exists?(id: params[:id])
  	  @service.cover_photo_id = params[:id]
  	  @service.save
    end
    redirect_to service_photos_path(@service.id)
  end

  def destroy
    Photo.find(params[:id]).destroy
    flash[:success] = "Photo deleted."
    redirect_to service_remove_photos_path(params[:service_id])
  end

  private

    def photo_params
    	params.require(:photo).permit(:img)
    end

end
