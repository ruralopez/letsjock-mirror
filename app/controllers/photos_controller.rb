class PhotosController < ApplicationController

  def create
    @user = User.find(params[:photo][:user_id])
    if signed_in? && current_user.id == @user.id
      @photo = @user.photos.build(params[:photo])
      if @photo.save
        Activity.new(:publisher_id => Publisher.find_by_user_id(@user.id).id, :photo_id => @photo.id, :act_type => "020").save
        redirect_to '/profile/' + @user.id.to_s
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end

end
