# $ rails generate controller PasswordResets new edit --no-test-framework
class PasswordResetsController < ApplicationController
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

  def edit # get edit_password_reset_path(token) /password_resets/<token>/edit
  end

  def update # patch password_reset_path(token) /password_resets/<token>
  end
end
