class UsersController < ApplicationController
  before_action :for_signed_in, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :not_for_signed_in,   only: [:new, :create]

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
  	  sign_in @user
  	  flash[:success] = "Welcome!"
  	  redirect_to @user
  	else
  	  render 'new'
  	end
  end

  def show
    if User.exists?(id: params[:id])
      @user = User.find(params[:id])
      @my_profile = current_user?(@user)
      @services = Service.approved.where(user_id: @user.id)
    else
      flash[:notice] =  "This user does not exist."
      redirect_to root_path
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :bio, :bio_pic)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

end
