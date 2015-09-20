class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # helpers are automatically included in views
  # here it is included in the base class of all controllers
  # so that functions defined there are also available to all controllers:
  # log_in(user): users_controller
  include SessionsHelper 

end
