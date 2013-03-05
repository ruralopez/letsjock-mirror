class VideosController < ApplicationController

  def create
    @user = User.find(params[:video][:user_id])
    if signed_in? && current_user.id == @user.id
      @video = @user.videos.build(params[:video])
      if @video.save
        Activity.new(:publisher_id => Publisher.find_by_user_id(@user.id).id, :video_id => @video.id, :act_type => "021").save
        redirect_to '/profile/' + @user.id.to_s
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end

end
