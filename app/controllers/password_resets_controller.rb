# $ rails generate controller PasswordResets new edit --no-test-framework
class PasswordResetsController < ApplicationController
  def new # get new_password_reset_path /password_resets/new
  end

  def create # post password_resets_path /password_resets
  end

  def edit # get edit_password_reset_path(token) /password_resets/<token>/edit
  end

  def update # patch password_reset_path(token) /password_resets/<token>
  end
end
