module SessionsHelper

  # Logs in the given user.
  # used in sessions_controller and users_controller
  def log_in(user)
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # check log in status then sets and returns the @current_user or nil
  def current_user
    # if a user just logged himself in, his user id will be saved in session
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)

    # if a user has previously logged himself in then closed the browser,
    # his user_id will be saved in cookie, encrypted by the signed method
    elsif (user_id = cookies.signed[:user_id])
      # raise # The tests still pass, so this branch is currently untested
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # used in sessions_controller and users_controller
  def logged_in?
    !current_user.nil?
  end

  # Forgets a persistent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Log out current user
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

end
