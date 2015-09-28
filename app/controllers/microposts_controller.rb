class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  
  # POST /microposts (microposts_path)
  def create
  end

  # DELETE /microposts/<id> (micropost_path(micropost))
  def destroy
  end
end
