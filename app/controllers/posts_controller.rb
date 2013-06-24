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
    
    if signed_in? && params[:post_content] != ""
      isAdmin = ( user.id == params[:writer_id].to_i )
      post = Post.new( :user_id => user.id, :event_id => params[:event_id] ? params[:event_id] : nil, :writer_id => params[:writer_id] )
      
      #Primero pasar URL's a A html tag
      #post.title = user.full_name + " post"
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
          photo = Photo.create(:user_id => params[:writer_id], :url => url)
          post.content += "<img class='img-rounded' src='#{url}' />"
          
          # Si es evento, debe tagearlo para que la foto quede en la vista de pictures
          if post.event_id
            Tags.create(:id1 => post.event_id, :type1 => "Event", :id2 => photo.id, :type2 => "Photo")
          end
        end
      end
      
      if post.save
        if isAdmin && params[:event_id] # Event new Post
          Activity.create(:publisher_id => Publisher.find_by_event_id( params[:event_id] ).id, :post_id => post.id, :act_type => "101")
        elsif isAdmin # Institution has a new post
          Activity.create(:publisher_id => Publisher.find_by_user_id( user ).id, :post_id => post.id, :act_type => "202")
        elsif params[:event_id] # User posted in a Event
          Activity.create(:publisher_id => Publisher.find_by_user_id( params[:writer_id] ).id, :post_id => post.id, :event_id => params[:event_id], :act_type => "032")
        else # User posted in Institution's wall
          Activity.create(:publisher_id => Publisher.find_by_user_id( params[:writer_id] ).id, :post_id => post.id, :user_id => user.id, :act_type => "003")
        end
        
        # Manda notificaciones a todos los administradores
        if user.isSponsor && user.admins.any?
          user.admins.each do |admin|
            Notification.create(:user_id => admin.id, :user2_id => params[:writer_id], :event_id => post.event_id, :aux_id => user.id, :read => false, :not_type => post.event_id ? "105" : "200")
          end
        end
      end
    end
    
    redirect_to request.referer
  end
  
  def remove_user_post
    user = User.find(params[:id])
    
    if signed_in? && user.inAdmins?(current_user) && params[:post_id] != ""
      post = Post.find(params[:post_id])
      
      # Elimina activities si existen
      if Activity.exists?(:post_id => post.id)
        Activity.where(:post_id => post.id).each { |a| a.destroy }
      end
      
      # Elimina comentarios si existen
      if Comment.exists?(:object_id => post.id, :object_type => "Post")
        cl = []
        Comment.where(:object_id => post.id, :object_type => "Post").each  do |c|
          cl.push(c.id)
          c.destroy
        end
        
        # Eliminar likes de los comentarios
        if Like.exists?(:object_id => cl, :object_type => "Comment")
          Like.where(:object_id => cl, :object_type => "Comment").each { |l| l.destroy }
        end
      end
      
      # Elimina likes si existen
      if Like.exists?(:object_id => post.id, :object_type => "Post")
        Like.where(:object_id => post.id, :object_type => "Post").each { |l| l.destroy }
      end
      
      post.destroy
    end
    
    redirect_to profile_path(user)
  end
end
