# sign up
class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  def show
    @user = User.find(params[:id])
    # debugger # can debug with byebug in rails console
  end

  def new # open register form
    @user = User.new
  end

  def create # post register form
    # @user = User.new(params[:user]) # not final implementation, Rails will raise an error because it's not secure
    
    # user_params is defined underneath after private keyword
    @user = User.new(user_params)

    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user # equals to user_url(@user)
    else
      # the form_for(@user) method in view will create the flash error messages for us
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update # path edit_user_path(@user)
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  
    def logged_in_user
      unless logged_in? # defined in sessions_helper.rb
        flash[:danger] = "Pleaser log in."
        redirect_to login_url
      end
    end

end
