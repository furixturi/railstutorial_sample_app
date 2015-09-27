# sign up, update, delete user
class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  def index
    @users = User.where(activated: true).paginate(page: params[:page], per_page: 20)
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])

    redirect_to root_url and return unless @user.activated == true
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
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url # equals to user_url(@user)
    else
      # the form_for(@user) method in view will create the flash error messages for us
      render 'new'
    end
  end

  def edit # open edit form
    # @user = User.find(params[:id]) # will be already assigned in before filter correct_user method
  end

  def update # path edit_user_path(@user), patch updated attributes
    # @user = User.find(params[:id]) # already assigned in before filter correct_user method
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy # delete method
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  
    # Confirm a logged in user
    def logged_in_user
      unless logged_in? # defined in sessions_helper.rb
        store_location # defined in sessions_helper.rb
        flash[:danger] = "Pleaser log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    # redirect to root if not the current_user
   def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
   end

   # confirm an admin user
   def admin_user
    redirect_to(root_url) unless current_user.admin?
   end
  
end
