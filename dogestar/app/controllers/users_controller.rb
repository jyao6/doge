class UsersController < ApplicationController
  before_action :for_signed_in, only: [:edit, :update, :change_password]
  before_action :correct_user,   only: [:edit, :update]
  before_action :not_for_signed_in,   only: [:new, :create, :forgot_password, :request_reset, :reset_password]

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      UserMailer.welcome_email(@user).deliver
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

  def change_password
    @user = current_user
    if !password_params.empty? and @user.update_attributes(password_params)
      flash[:success] = "Password changed."
      redirect_to @user
    end
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def forgot_password
  end

  def request_reset
    user = User.find_by_email(params[:email])
    if user.nil?
      flash.now[:error] = "The email address #{params[:email]} was not found."
    else
      token = User.new_remember_token
      if ResetPassword.new_token(user.id, token)
        UserMailer.reset_password(user, token).deliver
        flash.now[:success] = "Instructions to reset your password were sent to #{params[:email]}"
      else
        flash.now[:error] = "We could not process the request at this time. Please try again."
      end
    end
      render 'forgot_password'
  end

  def reset_password
    user = User.find_by_email(params[:email])
    if user.nil? or user.reset_password.nil?
      flash[:error] = "Invalid reset URL."
      redirect_to(root_path)
    elsif (user.reset_password.token != User.encrypt(params[:token])) or (user.reset_password.updated_at < 1.hours.ago)
      user.reset_password.destroy
      flash[:error] = "Reset URL expired. Please request a new reset URL to be emailed to you."
      redirect_to(forgot_password_path)
    else
      if !password_params.empty? and user.update_attributes(password_params)
        sign_in user
        user.reset_password.destroy
        flash[:success] = "Password successfully reset. Welcome back!"
        redirect_to(root_path)
      else
        @user = user
        render 'reset_password'
      end
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :bio, :avatar)
    end

    def password_params
      params.permit(:password, :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

end
