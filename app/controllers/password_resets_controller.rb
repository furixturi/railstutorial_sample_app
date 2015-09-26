# $ rails generate controller PasswordResets new edit --no-test-framework
class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :validate_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  # require password reset form (with one input for email)
  def new # get new_password_reset_path /password_resets/new
  end

  def create # post password_resets_path /password_resets
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  # set new password form (with two inputs for password and password_confirmation)
  def edit # get edit_password_reset_path(token) /password_resets/<token>/edit

  end

  def update # patch password_reset_path(token) /password_resets/<token>
    if params[:user][:password].empty?
      @user.errors.add(:password, "Can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # before filters
    def get_user
      @user = User.find_by(email: params[:email])
    end

    def validate_user
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired"
        redirect_to new_password_reset_url
      end
    end
end
