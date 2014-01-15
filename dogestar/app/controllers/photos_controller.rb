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
    if @photo.save
      flash[:success] = "Photo added!"
    else
      render 'new'
    end
  end

  def index

  end

  private

    def photo_params
    	params.require(:photo).permit(:img)
    end

end
