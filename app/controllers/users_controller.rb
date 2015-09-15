class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    # debugger
  end

  def new
    @user = User.new
  end

  def create
    # @user = User.new(params[:user]) # not final implementation, Rails will raise an error because it's not secure
    
    # user_params is defined underneath after private keyword
    @user = User.new(user_params)

    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user # equals to user_url(@user)
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  

end
