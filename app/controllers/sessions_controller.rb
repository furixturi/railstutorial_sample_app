# log in 
class SessionsController < ApplicationController
  def new # show login form
  end

  def create # submit login form post request
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])

      if user.activated?
        #log in the user and redirect to the url that the user tried to access before logging in, otherwise to user's show page
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user # redirect_back_or is defined in sessions_helper.rb
      else
        flash[:warning] = "Account not activated. Check your email for the activation link"
        redirect_to root_url
      end
    else
      # flash.now show message only in rendered page
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy # delete method to logout path
    log_out if logged_in?
    redirect_to root_url
  end
end
