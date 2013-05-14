class MessagesController < ApplicationController
  # GET /messages
  # GET /messages.json
  def inbox
    if signed_in?
      ids = Message.all(:conditions => ["user_id = ?", current_user.id]).collect(&:receiver_id) + Message.all(:conditions => ["receiver_id = ?", current_user.id]).collect(&:user_id)
      @users_contacted = User.all(:conditions => ["id IN (?) AND id != ?", ids, current_user.id]).sort{|a,b| a.last_message_with(current_user).created_at <=> b.last_message_with(current_user).created_at}.reverse
      @conversations = Hash.new
      @users_contacted.each do |user|
        @conversations[user.id] = current_user.messages_with(user).sort_by(&:created_at).reverse
      end
      current_user.unread_messages.each do |um|
        um.update_attributes(:read => true)
      end
      @message = Message.new
      @user = current_user
      @followers = @user.followers

      #@followers_list = []

      #unless @followers.blank?
        #@followers.each do |user|
          #@followers_list.push(user.full_name)
        #end
      #end

      @followers_list = Hash.new

      unless @followers.blank?
        @followers.each do |user|
          @followers_list[user.full_name] = user.id
        end
      end

      respond_to do |format|
        format.html # index.html.erb
        format.js { render :nothing => true }
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    @message = Message.find(params[:id])
    if signed_in? && (current_user.id == @message.user_id || current_user.id == @message.receiver_id)
      respond_to do |format|
        format.html # show.html.erb
        format.json { render :json => @message }
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end

  end

  # GET /messages/new
  # GET /messages/new.json
  def new
    @message = Message.new

    if signed_in?
      @user = current_user
      @followers = @user.followers

      @followers_list = Hash.new

      unless @followers.blank?
        @followers.each do |user|
          @followers_list[user.full_name] = user.id
        end
      end

    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to root_path
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @message }
    end
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(params[:message])
    if signed_in? && current_user.id == @message.user_id
      if User.find(@message.receiver_id).following?(User.find(@message.user_id))
        respond_to do |format|
          if @message.save
            format.html { redirect_to inbox_path, :notice => 'Message was successfully created.' }
            format.json { render :json => @message, :status => :created, :location => @message }
          else
            format.html { render :action => "new" }
            format.json { render :json => @message.errors, :status => :unprocessable_entity }
          end
        end
      else
        flash[:error] = "You can only send messages to your followers."
        redirect_to inbox_path
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end

  # PUT /messages/1
  # PUT /messages/1.json
  def update
    @message = Message.find(params[:id])
    if signed_in? && current_user.id == @message.user_id
      respond_to do |format|
        if @message.update_attributes(params[:message])
          format.html { redirect_to @message, :notice => 'Message was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render :action => "edit" }
          format.json { render :json => @message.errors, :status => :unprocessable_entity }
        end
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end


end
