class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])

    respond_to do |format|
      if @post.save
        Activity.new(:publisher_id => Publisher.find_by_event_id(params[:post][:event_id]).id, :post_id => @post.id, :act_type => "101").save
        format.html { redirect_to event_path(@post.event_id), :notice => 'Post was successfully created.' }
        format.json { render :json => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.json { render :json => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to @post, :notice => 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end
  
  def add_user_post
    user = User.find(params[:id])
    
    if signed_in? && user.inAdmins?(current_user) && params[:post_content] != ""
      post = Post.new(:user_id => user.id, :event_id => nil)
      
      #Primero pasar URL's a A html tag
      post.title = user.full_name + " post"
      post.content = params[:post_content].gsub( %r{http://[^\s<]+} ) do |url|
        if url[/(?:png|jpe?g|gif|svg)$/]
          "<img class='img-rounded' src='#{url}' />"
        else
          "<a href='#{url}'>#{url}</a>"
        end
      end
      
      if params[:post_picture] && params[:post_picture] != ""
        url = Photo.upload_file(params[:post_picture])
        
        if url && url != ""
          Photo.create(:user_id => user.id, :url => url)
          post.content += "<img class='img-rounded' src='#{url}' />"
        end
      end
      
      post.save
    end
    
    redirect_to profile_path(user)
  end
end
