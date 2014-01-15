class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  private
    def not_for_signed_in
      if signed_in?
        redirect_to controller: "services", action: "index"
      end
    end

    def for_signed_in
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def for_service_owner(service_id)
      if Service.exists?(id: service_id)
        @service = Service.find(service_id)
        if @service.user_id != current_user.id
          flash[:notice] = "You don't have permission to edit this service."
          redirect_to action: "index" 
        end
      else
        flash[:notice] =  "This service does not exist. :("
        redirect_to root_path
      end     
    end
end
