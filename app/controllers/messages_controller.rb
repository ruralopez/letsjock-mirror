class MessagesController < ApplicationController
  # GET /messages
  # GET /messages.json
  def index
    if signed_in?
      @messages = Message.all(:conditions => ["user_id = ? OR receiver_id = ?", current_user.id, current_user.id])

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @messages }
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
        format.json { render json: @message }
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

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @message }
    end
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(params[:message])
    if signed_in? && current_user.id == @message.user_id
      respond_to do |format|
        if @message.save
          format.html { redirect_to @message, notice: 'Message was successfully created.' }
          format.json { render json: @message, status: :created, location: @message }
        else
          format.html { render action: "new" }
          format.json { render json: @message.errors, status: :unprocessable_entity }
        end
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
          format.html { redirect_to @message, notice: 'Message was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @message.errors, status: :unprocessable_entity }
        end
      end
    else
      flash[:error] = "You must be logged in."
      sign_out
      redirect_to signin_path
    end
  end

end
