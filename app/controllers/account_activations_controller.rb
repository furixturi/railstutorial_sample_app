# $ rails generate controller AccountActivations --no-test-framework
class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && user.authenticated?(:activation, params[:id])
    end
  end
end
