class PhotosController < ApplicationController

  def create
    @user = User.find(params[:photo][:user_id])
    @photo = @user.photos.build(params[:photo])
    if @photo.save
      redirect_to '/profile/' + @user.id.to_s
    end
  end

end
