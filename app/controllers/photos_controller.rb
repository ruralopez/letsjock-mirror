class PhotosController < ApplicationController

  def index
    @photos = Photo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @photos }
    end
  end

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

  def destroy
    @photo = Photo.find(params[:id])
    if signed_in? && current_user.id == 1
      Activity.where(["publisher_id = ? AND photo_id = ? AND act_type = ?", Publisher.find_by_user_id(@photo.user_id).id,@photo.id, "020"]).first.destroy
      @photo.destroy

      respond_to do |format|
        format.html { redirect_to photos_url }
        format.json { head :no_content }
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end

end
