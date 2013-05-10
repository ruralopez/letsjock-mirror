class PhotosController < ApplicationController
  before_filter :open_aws_connection, :only => [:create, :destroy]
  @@BUCKET = 'letsjock-photos'
  
  def index
    @photos = Photo.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @photos }
    end
  end
  
  def open_aws_connection
    AWS::S3::Base.establish_connection!(
      :access_key_id     => 'AKIAJOMNP4NKMHY3AZOA',
      :secret_access_key => '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'
    )
  end

  def create
    new_photo = params[:photo] #Para llevar temporalmente las variables del form
    @user = User.find(params[:photo][:user_id])
    
    if signed_in? && current_user.id == @user.id
      @photo = Photo.create(:user_id => @user.id, :title => new_photo['title'], :comment => new_photo['comment'], :sport_id => new_photo['sport_id'])
      
      if fileUp = new_photo['file']
        #filename = @photo.id.to_s + File.extname(fileUp.original_filename)
        filename = rand(36**32).to_s(36) + File.extname(fileUp.original_filename)
        
        # Carga el archivo
        AWS::S3::S3Object.store(filename, fileUp.read, @@BUCKET, :access => :public_read)
        url = AWS::S3::S3Object.url_for(filename, @@BUCKET, :authenticated => false)
        @photo.url = url
      else
        @photo.url = new_photo['url']
      end
      
      if @photo.save
        Activity.new(:publisher_id => Publisher.find_by_user_id(@user.id).id, :photo_id => @photo.id, :act_type => "020").save
        redirect_to request.referer
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
      @activities = Activity.where(["publisher_id = ? AND photo_id = ? AND act_type = ?", Publisher.find_by_user_id(@photo.user_id).id,@photo.id, "020"])
      
      if @activities.count > 0
        @activities.first.destroy
      end
      
      if @photo.url.include? "s3.amazonaws.com/letsjock-photos/"
        AWS::S3::S3Object.find(@photo.url.split("/").last, @@BUCKET).delete
      end
      
      @photo.destroy
      
      respond_to do |format|
        format.html { redirect_to request.referer }
        format.json { head :no_content }
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end
end
