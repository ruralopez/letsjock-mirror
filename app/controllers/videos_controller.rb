class VideosController < ApplicationController

  def create
    @user = User.find(params[:video][:user_id])
    if signed_in? && current_user.id == @user.id
      @video = @user.videos.build(params[:video])
      if @video.save
        redirect_to '/profile/' + @user.id.to_s
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end

end
