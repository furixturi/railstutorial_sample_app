class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  # POST /microposts (microposts_path)
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  # DELETE /microposts/<id> (micropost_path(micropost))
  def destroy
  end

  private
    def micropost_params
      params.require(:micropost).permit(:content)
    end
end
